locals {

  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.selected.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.selected.identity_store_ids)[0]

  managed_permission_set_attachments = flatten([
    for set in var.managed_permission_sets : [
      for policy in set.attached_policies : {
        name        = set.name
        description = set.description
        policy      = policy
      }
    ] if set.attached_policies != []
  ])

  sso_group_assignments = flatten([
    for group in var.sso_groups : [
      for account in group.accounts : {
        name           = group.name
        permission_set = group.permission_set
        account        = account
      }
    ] if group.accounts != []
  ])

  sso_user_assignments = flatten([
    for user in var.sso_users : [
      for account in user.accounts : {
        name           = user.name
        permission_set = user.permission_set
        account        = account
      }
    ] if user.accounts != []
  ])

  accounts = var.delegated_sso_admin ? data.aws_organizations_organization.this[0].accounts[*] : var.accounts_list
}
