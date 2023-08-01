resource "aws_iam_role" "vanta_auditor" {
  name               = "vanta-auditor"
  assume_role_policy = data.aws_iam_policy_document.vanta_assume_role.json
  managed_policy_arns = [
    aws_iam_policy.vanta_access.arn,
    "arn:aws:iam::aws:policy/SecurityAudit",
    ]
}

resource "aws_iam_policy" "vanta_access" {
  name   = "vanta-access"
  policy = data.aws_iam_policy_document.vanta_access.json
}
