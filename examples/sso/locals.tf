locals {

  # NB:  These groups need to exist
  # NB:  1:1 mapping of permission set to AD Group
  sso_groups = [
    {
      name           = "master-admins"
      accounts       = ["org-master-account"]
      permission_set = "AdministratorAccess"
    }
  ]

  # maps a permission set to a list of IAM Policies
  managed_permission_sets = [
    {
      name              = "AdministratorAccess"
      description       = "Full Administrator Access"
      attached_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }
  ]

  # maps a permission set to an inline IAM Policy (singlular)
  inline_permission_sets = [
    {
      name          = "custom_permission_set"
      description   = "Description"
      inline_policy = data.aws_iam_policy_document.custom_permission_set.json
    }
  ]

}
