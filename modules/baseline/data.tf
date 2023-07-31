data "aws_iam_policy_document" "vanta_assume_role" {
  count = local.enable_vanta_integration ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.vanta_account_id]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [var.vanta_external_id]
    }
  }
}

data "aws_iam_policy_document" "vanta_additional" {
  count = local.enable_vanta_integration ? 1 : 0

  statement {
    effect = "Deny"
    actions = [
      "datapipeline:EvaluateExpression",
      "datapipeline:QueryObjects",
      "rds:DownloadDBLogFilePortion"
    ]
    resources = ["*"]
  }
}
