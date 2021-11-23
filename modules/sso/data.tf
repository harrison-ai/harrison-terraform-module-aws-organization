data "aws_organizations_organization" "this" {}

data "aws_ssoadmin_instances" "selected" {}

# discover the list of groups that have been provisioned in AzureAD
data "aws_identitystore_group" "this" {
  for_each = toset([for group in var.sso_groups : group.name])


  identity_store_id = local.identity_store_id

  filter {
    attribute_path  = "DisplayName"
    attribute_value = each.key
  }
}

# discover the list of users that have been provisioned in AzureAD
data "aws_identitystore_user" "this" {
  for_each = toset([for user in var.sso_users : user.name])


  identity_store_id = local.identity_store_id

  filter {
    attribute_path  = "UserName"
    attribute_value = each.key
  }
}
