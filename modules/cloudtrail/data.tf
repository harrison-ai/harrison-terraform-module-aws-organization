data "aws_caller_identity" "master" {}

data "aws_iam_policy_document" "kms" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.master_account_id}:root"
      ]
    }
  }

  statement {
    sid       = "Allow CloudTrail to encrypt logs"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:aws:cloudtrail:*:${local.master_account_id}:trail/*"
      ]
    }
  }

  statement {
    sid       = "Allow CloudTrail to describe key"
    effect    = "Allow"
    actions   = ["kms:DescribeKey"]
    resources = ["*"]
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }
  }

  statement {
    sid    = "Allow principals in the account to decrypt log files"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
        local.master_account_id
      ]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:aws:cloudtrail:*:aws-account-id:trail/*"
      ]
    }
  }

  statement {
    sid       = "Allow alias creation during setup"
    effect    = "Allow"
    actions   = ["kms:CreateAlias"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
        local.master_account_id
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "ec2.region.amazonaws.com"
      ]
    }
  }

  statement {
    sid    = "Enable cross account log decryption"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
        local.master_account_id
      ]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:aws:cloudtrail:*:${local.master_account_id}:trail/*"
      ]
    }
  }

}


data "aws_iam_policy_document" "bucket" {
  statement {
    sid    = "AWSCloudTrailAclCheck20150319"
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      aws_s3_bucket.this.arn
    ]
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }
  }
  statement {
    sid    = "AWSCloudTrailWrite20150319"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/AWSLogs/*"
    ]
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
# {
#     "Version": "2012-10-17",
#     "Id": "Key policy created by CloudTrail",
#     "Statement": [
#         {
#             "Sid": "Enable IAM User Permissions",
#             "Effect": "Allow",
#             "Principal": {"AWS": [
#                 "arn:aws:iam::aws-account-id:root",
#                 "arn:aws:iam::aws-account-id:user/username"
#             ]},
#             "Action": "kms:*",
#             "Resource": "*"
#         },
#         {
#             "Sid": "Allow CloudTrail to encrypt logs",
#             "Effect": "Allow",
#             "Principal": {"Service": ["cloudtrail.amazonaws.com"]},
#             "Action": "kms:GenerateDataKey*",
#             "Resource": "*",
#             "Condition": {"StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:aws-account-id:trail/*"}}
#         },
#         {
#             "Sid": "Allow CloudTrail to describe key",
#             "Effect": "Allow",
#             "Principal": {"Service": ["cloudtrail.amazonaws.com"]},
#             "Action": "kms:DescribeKey",
#             "Resource": "*"
#         },
#         {
#             "Sid": "Allow principals in the account to decrypt log files",
#             "Effect": "Allow",
#             "Principal": {"AWS": "*"},
#             "Action": [
#                 "kms:Decrypt",
#                 "kms:ReEncryptFrom"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "StringEquals": {"kms:CallerAccount": "aws-account-id"},
#                 "StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:aws-account-id:trail/*"}
#             }
#         },
#         {
#             "Sid": "Allow alias creation during setup",
#             "Effect": "Allow",
#             "Principal": {"AWS": "*"},
#             "Action": "kms:CreateAlias",
#             "Resource": "*",
#             "Condition": {"StringEquals": {
#                 "kms:ViaService": "ec2.region.amazonaws.com",
#                 "kms:CallerAccount": "aws-account-id"
#             }}
#         },
#         {
#             "Sid": "Enable cross account log decryption",
#             "Effect": "Allow",
#             "Principal": {"AWS": "*"},
#             "Action": [
#                 "kms:Decrypt",
#                 "kms:ReEncryptFrom"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "StringEquals": {"kms:CallerAccount": "aws-account-id"},
#                 "StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:aws-account-id:trail/*"}
#             }
#         }
#     ]
# }
