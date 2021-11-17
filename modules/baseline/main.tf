##  -----  Password Policy  -----  ##
resource "aws_iam_account_password_policy" "default" {

  minimum_password_length        = 20
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}


##  -----  S3 Account Public Block  -----  ##
resource "aws_s3_account_public_access_block" "this" {

  account_id              = local.account_id
  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


##  -----  EC2 Default Encryption  -----  ##
resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}


##  -----  Budget  -----  ##
resource "aws_budgets_budget" "this" {
  count = local.account.enable_budget ? 1 : 0

  name         = "default-budget"
  budget_type  = "COST"
  limit_amount = local.account.budget_limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"
  cost_types {
    include_credit             = true
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = false
    include_subscription       = true
    include_support            = false
    include_tax                = false
    include_upfront            = true
    use_blended                = false
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "60"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [local.account.email, var.central_budget_nofication]
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "80"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [local.account.email, var.central_budget_nofication]
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "100"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [local.account.email, var.central_budget_nofication]
  }
}


##  -----  Delete the default VPC  -----  ##
data "external" "delete_default_vpc" {
  program = ["python", "${path.module}/delete-default-vpc.py"]
  query = {
    account_id = local.account_id
  }
}
