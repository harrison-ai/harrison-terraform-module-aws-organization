locals {
  account    = [for a in var.accounts : a if a.name == var.name][0]
  account_id = var.account_ids[var.name]
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
