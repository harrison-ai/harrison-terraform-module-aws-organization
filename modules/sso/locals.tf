locals {

  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.selected.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.selected.identity_store_ids)[0]

  permission_set_attachments = flatten([
    for set in var.permission_sets : [
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

  accounts = data.aws_organizations_organization.this.accounts[*]

}