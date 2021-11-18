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
