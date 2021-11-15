module "sso" {
  source = "../../modules/sso"

  permission_sets = local.permission_sets
  sso_groups      = local.sso_groups

}
