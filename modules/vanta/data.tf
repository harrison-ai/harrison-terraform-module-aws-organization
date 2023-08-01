data "aws_iam_policy_document" "vanta_assume_role" {
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

data "aws_iam_policy_document" "vanta_access" {

  dynamic "statement" {
    for_each = var.enable_identity_center_monitoring ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "identitystore:Describe*",
        "identitystore:Get*",
        "identitystore:IsMemberInGroups",
        "identitystore:List*"
      ]
      resources = ["*"]
    }
  }
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
