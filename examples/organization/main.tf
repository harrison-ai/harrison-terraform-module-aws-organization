##  -----  Organization  -----  ##
module "org" {
  source = "../../modules/organization"

  aws_service_access_principals = local.aws_service_access_principals
  enabled_policy_types          = local.enabled_policy_types
  top_level_org_units           = local.top_level_org_units
  child_org_units               = local.child_org_units
  accounts                      = local.accounts
  service_control_policies      = local.service_control_policies
}

##  -----  CloudTrail  -----  ##
module "cloudtrail" {
  source = "../../modules/cloudtrail"

  account_id      = module.harrison.member_accounts["sch-testorg-audit"]
  cloudtrail_name = "${local.organization}-cloudtrail"
  bucket_name     = "${local.organization}-cloudtrail"
  project         = local.project
  repo            = local.repo
}

##  -----  Member Account Baseline Configuration  -----  ##
##  -----  Include a module for each member account  -----  ##
module "account_one" {
  source = "../../modules/baseline"

  name                      = "account-one"
  account_ids               = module.org.member_accounts
  accounts                  = local.accounts
  central_budget_nofication = "dataengineering@harrison.ai"
  region                    = local.region
  profile                   = local.profile
  project                   = local.project
  repo                      = local.repo
}

module "account_two" {
  source = "../../modules/baseline"

  name                      = "account-two"
  account_ids               = module.org.member_accounts
  accounts                  = local.accounts
  central_budget_nofication = "dataengineering@harrison.ai"
  region                    = local.region
  profile                   = local.profile
  project                   = local.project
  repo                      = local.repo
}
