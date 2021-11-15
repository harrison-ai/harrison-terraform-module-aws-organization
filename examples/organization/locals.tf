locals {

  region       = "ap-southeast-2"
  profile      = "my-profile"
  repo         = "my-repo"
  project      = "my-project"
  organization = "harrison"

  accounts_input = fileset("${path.root}", "./input/*.yml")
  accounts       = merge([for file in local.accounts_input : yamldecode(file(file))]...)

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
    },
    {
      name        = "block_disable_ebs_encryption"
      description = "Block disabling the default EBS encryption"
      policy      = data.aws_iam_policy_document.block_disable_ebs_encryption.json
    },
  ]

  top_level_org_units = [
    {
      name          = "ou-one"
      uuid          = "a4856923-00f2-a13e-9148-1238136a082c"
      attached_scps = []
    },
    {
      name          = "ou-two"
      uuid          = "18482f69-aa61-1d20-cdc8-f4801f313052"
      attached_scps = []
    },
    {
      name          = "ou-three"
      uuid          = "50df0fba-fd1f-3337-5ee5-8fda8dd53eed"
      attached_scps = []
    }
  ]

  #  NB: should be a direct descendant of top_level_org_units
  child_org_units = [
    {
      name          = "ou-one-child-one"
      uuid          = "5d41dd0c-561a-eab4-ad53-4da7753a89b7"
      attached_scps = ["block_access_keys", "block_leave_organization", "block_disable_ebs_encryption"]
      parent = {
        name = "ou-one"
        uuid = "a4856923-00f2-a13e-9148-1238136a082c"
      }
    },
    {
      name          = "ou-one-child-two"
      uuid          = "468c458f-515f-063a-8ca5-2d2386bde50e"
      attached_scps = []
      parent = {
        name = "ou-one"
        uuid = "a4856923-00f2-a13e-9148-1238136a082c"
      }
    }
  ]

}
