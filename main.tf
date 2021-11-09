##  -----  Organization  -----  ##
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.aws_service_access_principals
  feature_set                   = "ALL"
  enabled_policy_types          = var.enabled_policy_types
}


##  -----  OU's  -----  ##
resource "aws_organizations_organizational_unit" "top_level_org_units" {
  for_each = { for ou in var.top_level_org_units : ou.uuid => ou }

  name      = each.value.name
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "child_org_units" {
  for_each = { for ou in var.child_org_units : ou.uuid => ou }

  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.top_level_org_units[each.value.parent.uuid].id
}


##  -----  Accounts  -----  ##
resource "aws_organizations_account" "this" {
  for_each = { for account in var.accounts : account.name => account }

  name                       = each.value.name
  email                      = each.value.email
  iam_user_access_to_billing = each.value.iam_user_access_to_billing
  parent_id                  = each.value.parent.uuid != null ? [for ou in local.org_units : ou.id if ou.uuid == each.value.parent.uuid][0] : aws_organizations_organization.org.roots[0].id

  depends_on = [
    aws_organizations_organization.org
  ]

  #  Terraform will always try replace an imported resource if this isn't set.
  #  See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account
  lifecycle {
    ignore_changes = [iam_user_access_to_billing]
  }
}

##  -----  Service Control Policies  -----  ##
resource "aws_organizations_policy" "this" {
  for_each = { for scp in var.service_control_policies : scp.name => scp }

  name        = each.value.name
  description = each.value.description
  type        = "SERVICE_CONTROL_POLICY"
  content     = each.value.policy
}

# https://www.terraform.io/docs/language/functions/flatten.html#flattening-nested-structures-for-for_each
resource "aws_organizations_policy_attachment" "this" {
  for_each = { for attach in local.scp_attachments : "${attach.scp}.${attach.ou_uuid}" => attach }

  policy_id = aws_organizations_policy.this[each.value.scp].id
  target_id = aws_organizations_organizational_unit.child_org_units[each.value.ou_uuid].id
}
