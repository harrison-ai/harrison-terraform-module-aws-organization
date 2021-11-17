resource "aws_ssoadmin_permission_set" "this" {
  for_each = { for permission in var.permission_sets : permission.name => permission }

  name         = each.value.name
  description  = each.value.description
  instance_arn = local.sso_instance_arn
  session_duration = "PT12H"
}


#  attaches an IAM Policy to a permission set
resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = { for attach in local.permission_set_attachments : "${attach.name}.${attach.policy}" => attach }

  instance_arn       = local.sso_instance_arn
  managed_policy_arn = each.value.policy
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.name].arn
}


#  maps an AD Group to a permission set and attaches it to an account(s)
resource "aws_ssoadmin_account_assignment" "this" {
  for_each = { for assignment in local.sso_group_assignments : "${assignment.name}.${assignment.account}" => assignment }

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  principal_id       = data.aws_identitystore_group.this[each.value.name].group_id
  principal_type     = "GROUP"
  target_type        = "AWS_ACCOUNT"
  target_id          = [for account in local.accounts : account.id if account.name == each.value.account][0]


}
