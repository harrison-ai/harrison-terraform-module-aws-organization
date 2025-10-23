resource "aws_iam_role" "vanta_auditor" {
  name               = "vanta-auditor"
  assume_role_policy = data.aws_iam_policy_document.vanta_assume_role.json
}

resource "aws_iam_policy" "vanta_access" {
  name   = "vanta-access"
  policy = data.aws_iam_policy_document.vanta_access.json
}

resource "aws_iam_role_policy_attachments_exclusive" "vanta" {
  role_name = aws_iam_role.vanta_auditor.name
  policy_arns = [
    "arn:aws:iam::aws:policy/SecurityAudit",
    aws_iam_policy.vanta_access.arn,
  ]
}
