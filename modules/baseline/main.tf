# ##  -----  Password Policy  -----  ##
resource "aws_iam_account_password_policy" "default" {
  count = var.destroy ? 0 : 1

  minimum_password_length        = var.min_iam_password_length
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}


##  -----  (Optional) S3 Account Public Block  -----  ##
resource "aws_s3_account_public_access_block" "this" {
  count = (var.destroy || var.create_s3_account_public_access_block == 0) ? 0 : 1

  account_id              = var.config.account_id
  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##  -----  Default EBS Encryption  -----  ##
resource "aws_ebs_encryption_by_default" "this" {
  count = var.destroy ? 0 : 1

  enabled = true
}


##  -----  Budget  -----  ##
resource "aws_budgets_budget" "this" {
  count = (var.destroy || var.config.budget_limit_amount == null) ? 0 : 1

  name         = "default-budget"
  budget_type  = "COST"
  limit_amount = var.config.budget_limit_amount
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
    subscriber_email_addresses = compact([var.config.email, var.central_budget_notification])
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "80"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = compact([var.config.email, var.central_budget_notification])
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "100"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = compact([var.config.email, var.central_budget_notification])
  }
}
