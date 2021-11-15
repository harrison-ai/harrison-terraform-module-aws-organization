data "aws_iam_policy_document" "block_root_user" {
  statement {
    sid       = "AllowAll"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
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

data "aws_iam_policy_document" "block_s3_account_public_block" {
  statement {
    effect = "Deny"
    actions = [
      "s3:PutAccountPublicAccessBlock"
    ]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "block_disable_ebs_encryption" {
  statement {
    effect = "Deny"
    actions = [
      "ec2:DisableEbsEncryptionByDefault"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "restrict_current_region" {
  statement {
    effect = "Deny"
    actions = [
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
