resource "aws_iam_role" "vanta_auditor" {
  name               = "vanta-auditor"
  assume_role_policy = data.aws_iam_policy_document.vanta_assume_role.json
}

resource "aws_iam_policy" "vanta_access" {
  name   = "vanta-access"
  policy = data.aws_iam_policy_document.vanta_access.json
}

resource "aws_iam_role_policy_attachment" "vanta_access" {
  role       = aws_iam_role.vanta_auditor.name
  policy_arn = aws_iam_policy.vanta_access.arn
}

resource "aws_iam_role_policy_attachment" "vanta_security_audit" {
  role       = aws_iam_role.vanta_auditor.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}
