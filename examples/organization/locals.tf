locals {

  region       = "ap-southeast-2"
  profile      = "my-profile"
  repo         = "my-repo"
  project      = "my-project"
  organization = "harrison"

  allowed_regions = [local.region]

  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "sso.amazonaws.com"
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY"
  ]

  service_control_policies = [
    {
      name        = "block_root_user"
      description = "Block usage of the root user"
      policy      = data.aws_iam_policy_document.block_root_user.json
    },
    {
      name        = "block_access_keys"
      description = "Block the creation of IAM users and access keys"
      policy      = data.aws_iam_policy_document.block_access_keys.json
    },
    {
      name        = "block_leave_organization"
      description = "Block accounts from leaving the organization"
      policy      = data.aws_iam_policy_document.block_access_keys.json
    }
  ]

  top_level_org_units = [
    {
      name          = "ou-one"
      uuid          = "a4856923-00f2-a13e-9148-1238136a082c"
      attached_scps = ["block_leave_organization"]
    },
    {
      name          = "ou-two"
      uuid          = "18482f69-aa61-1d20-cdc8-f4801f313052"
      attached_scps = ["block_leave_organization"]
    },
    {
      name          = "ou-three"
      uuid          = "50df0fba-fd1f-3337-5ee5-8fda8dd53eed"
      attached_scps = ["block_leave_organization"]
    }
  ]

  #  NB: should be a direct descendant of top_level_org_units
  child_org_units = [
    {
      name          = "production"
      uuid          = "5d41dd0c-561a-eab4-ad53-4da7753a89b7"
      attached_scps = ["block_access_keys"]
      parent = {
        name = "ou-one"
        uuid = "a4856923-00f2-a13e-9148-1238136a082c"
      }
    },
    {
      name          = "development"
      uuid          = "468c458f-515f-063a-8ca5-2d2386bde50e"
      attached_scps = []
      parent = {
        name = "ou-one"
        uuid = "a4856923-00f2-a13e-9148-1238136a082c"
      }
    }
  ]

  member_accounts = [
    {
      name                       = "prod-workloads"
      email                      = "aws.prod.workloads@example.com"
      iam_user_access_to_billing = "ALLOW"
      enable_budget              = true
      budget_limit_amount        = "200"
      parent = {
        name = "production"
        uuid = "5d41dd0c-561a-eab4-ad53-4da7753a89b6"
      }
    },
    {
      name                       = "dev-workloads"
      email                      = "aws.dev.workloads@example.com"
      iam_user_access_to_billing = "ALLOW"
      enable_budget              = true
      budget_limit_amount        = "200"
      parent = {
        name = null
        uuid = null
      }
    }
  ]

}
