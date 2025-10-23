moved {
  from = aws_iam_account_password_policy.default[0]
  to   = aws_iam_account_password_policy.default
}

moved {
  from = aws_ebs_encryption_by_default.this[0]
  to   = aws_ebs_encryption_by_default.this
}
