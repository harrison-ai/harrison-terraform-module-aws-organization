resource "aws_ssoadmin_permission_set" "this" {
  for_each = merge({ for p in var.managed_permission_sets : p.name => p }, { for p in var.inline_permission_sets : p.name => p })

  name             = each.value.name
  description      = each.value.description
  instance_arn     = local.sso_instance_arn
  session_duration = try(each.value.session_duration, "PT12H")
}

#  attaches permission boundaries
resource "aws_ssoadmin_permissions_boundary_attachment" "this" {
  for_each = {
    for p in concat(var.managed_permission_sets, var.inline_permission_sets) :
    p.name => p if p.permissions_boundary != null
  }

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn

  #  the two dynamic blocks are enforced to be mutually exclusive
  #  sets customer_managed policy if not null
  dynamic "permissions_boundary" {
    for_each = each.value.permissions_boundary.customer_managed_policy_reference != null ? [each.value.permissions_boundary.customer_managed_policy_reference] : []
    content {
      dynamic "customer_managed_policy_reference" {
        for_each = [permissions_boundary.value]
        content {
          name = customer_managed_policy_reference.value.name
          path = customer_managed_policy_reference.value.path
        }
      }
    }
  }

  #  sets managed_policy_arn if not null
  dynamic "permissions_boundary" {
    for_each = each.value.permissions_boundary.managed_policy_arn != null ? [each.value.permissions_boundary.managed_policy_arn] : []
    content {
      managed_policy_arn = permissions_boundary.value
    }
  }
}

#  attaches an AWS Managed IAM Policy to a permission set
resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = { for attach in local.managed_permission_set_attachments : "${attach.name}.${attach.policy}" => attach }

  instance_arn       = local.sso_instance_arn
  managed_policy_arn = each.value.policy
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.name].arn
}


#  attaches an inline / custom IAM Policy to a permission set
resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = { for set in var.inline_permission_sets : set.name => set }

  instance_arn       = local.sso_instance_arn
  inline_policy      = each.value.inline_policy
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.name].arn
}


#  maps an AD Group to a permission set and attaches it to an account(s)
resource "aws_ssoadmin_account_assignment" "groups" {
  for_each = { for assignment in local.sso_group_assignments : "${assignment.name}.${assignment.account}" => assignment }

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  principal_id       = data.aws_identitystore_group.this[each.value.name].group_id
  principal_type     = "GROUP"
  target_type        = "AWS_ACCOUNT"
  target_id          = [for account in local.accounts : account.id if account.name == each.value.account][0]
}

#  maps an AD Group to a permission set and attaches it to an account(s)
resource "aws_ssoadmin_account_assignment" "users" {
  for_each = { for assignment in local.sso_user_assignments : "${assignment.name}.${assignment.account}" => assignment }

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  principal_id       = data.aws_identitystore_user.this[each.value.name].user_id
  principal_type     = "USER"
  target_type        = "AWS_ACCOUNT"
  target_id          = [for account in local.accounts : account.id if account.name == each.value.account][0]
}
