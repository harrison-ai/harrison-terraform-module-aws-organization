data "aws_iam_policy_document" "sandbox" {
  source_policy_documents = [
    data.aws_iam_policy_document.block_root_user.json,
    data.aws_iam_policy_document.block_access_keys.json,
    data.aws_iam_policy_document.block_leave_organization.json,
    data.aws_iam_policy_document.protect_security_settings.json,
    data.aws_iam_policy_document.restrict_current_region.json,
    data.aws_iam_policy_document.deny_internet_access.json,
    data.aws_iam_policy_document.deny_create_vpc.json,
    data.aws_iam_policy_document.deny_modify_budget.json,
    data.aws_iam_policy_document.protect_org_roles.json,
    data.aws_iam_policy_document.deny_modify_vpc_tags.json,
  ]
}

data "aws_iam_policy_document" "block_root_user" {
  statement {
    sid       = "BlockRootUser"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::*:root"
      ]
    }
  }
}

data "aws_iam_policy_document" "block_access_keys" {
  statement {
    effect = "Deny"
    actions = [
      "iam:CreateAccessKey",
      "iam:CreateUser"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "block_leave_organization" {
  statement {
    effect = "Deny"
    actions = [
      "organizations:LeaveOrganization"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "protect_security_settings" {
  statement {
    effect = "Deny"
    actions = [
      "access-analyzer:DeleteAnalyzer",
      "ec2:DisableEbsEncryptionByDefault",
      "s3:PutAccountPublicAccessBlock",
    ]
    resources = ["*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/OrganizationAccountAccessRole"]
    }
  }
}

data "aws_iam_policy_document" "restrict_current_region" {
  statement {
    effect = "Deny"
    not_actions = [
      "a4b:*",
      "acm:*",
      "aws-marketplace-management:*",
      "aws-marketplace:*",
      "aws-portal:*",
      "budgets:*",
      "ce:*",
      "chime:*",
      "cloudfront:*",
      "config:*",
      "cur:*",
      "directconnect:*",
      "ec2:DescribeRegions",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpnGateways",
      "fms:*",
      "globalaccelerator:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "kms:*",
      "mobileanalytics:*",
      "networkmanager:*",
      "organizations:*",
      "pricing:*",
      "route53:*",
      "route53domains:*",
      "s3:GetAccountPublic*",
      "s3:ListAllMyBuckets",
      "s3:PutAccountPublic*",
      "shield:*",
      "sts:*",
      "support:*",
      "trustedadvisor:*",
      "waf-regional:*",
      "waf:*",
      "wafv2:*",
      "wellarchitected:*"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = local.allowed_regions
    }
  }
}

data "aws_iam_policy_document" "deny_internet_access" {
  statement {
    effect = "Deny"
    actions = [
      "ec2:AttachInternetGateway",
      "ec2:CreateInternetGateway",
      "ec2:CreateEgressOnlyInternetGateway",
      "ec2:CreateVpcPeeringConnection",
      "ec2:AcceptVpcPeeringConnection",
      "globalaccelerator:Create*",
      "globalaccelerator:Update*"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/OrganizationAccountAccessRole"]
    }
  }
}

data "aws_iam_policy_document" "deny_create_vpc" {
  statement {
    effect = "Deny"
    actions = [
      "ec2:CreateDefaultVpc",
      "ec2:CreateTransitGatewayVpcAttachment",
      "ec2:CreateVpc",
      "ec2:CreateVpcEndpoint",
      "ec2:CreateVpcEndpointConnectionNotification",
      "ec2:CreateVpcEndpointServiceConfiguration",
      "ec2:CreateVpcPeeringConnection"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/OrganizationAccountAccessRole"]
    }
  }
}

data "aws_iam_policy_document" "deny_modify_budget" {
  statement {
    sid    = "DenyModifyingBudget"
    effect = "Deny"
    actions = [
      "budgets:ModifyBudget",
      "budgets:DeleteBudgetAction"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/OrganizationAccountAccessRole"]
    }
  }
}

data "aws_iam_policy_document" "deny_modify_vpc_tags" {
  statement {
    sid    = "DenyModifyVpcTags"
    effect = "Deny"
    actions = [
      "ec2:DeleteTags",
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:*:*:vpc/*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/OrganizationAccountAccessRole"]
    }
  }
}

data "aws_iam_policy_document" "protect_org_roles" {
  statement {
    sid    = "DenyModifySpecificRoles"
    effect = "Deny"
    actions = [
      "iam:AttachRolePolicy",
      "iam:DeleteRole",
      "iam:DeleteRolePermissionsBoundary",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:PutRolePolicy",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateRole",
      "iam:UpdateRoleDescription"
    ]
    resources = local.protected_iam_roles
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/OrganizationAccountAccessRole"]
    }
  }
}
