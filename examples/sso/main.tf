module "sso" {
  source = "../../modules/sso"

  managed_permission_sets = []
  inline_permission_sets  = local.inline_permission_sets
  sso_groups              = local.sso_groups
  sso_users               = []

  #  if delegated sso admin is enabled
  delegated_sso_admin = true
  accounts_list       = local.accounts_list

}
