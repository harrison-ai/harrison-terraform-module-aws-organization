output "member_accounts" {
  value = { for k, v in aws_organizations_account.this : k => v.id }
}

output "aws_org_member_accounts" {
  value = aws_organizations_organization.org.non_master_accounts
}
