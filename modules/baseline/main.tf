# ##  -----  Password Policy  -----  ##
resource "aws_iam_account_password_policy" "default" {
  minimum_password_length        = var.min_iam_password_length
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}


##  -----  (Optional) S3 Account Public Block  -----  ##
resource "aws_s3_account_public_access_block" "this" {
  count = var.create_s3_account_public_access_block ? 1 : 0

  account_id              = var.aws_account_id
  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##  -----  Default EBS Encryption  -----  ##
resource "aws_ebs_encryption_by_default" "this" {
  for_each = toset(var.allowed_regions)

  region  = each.key
  enabled = true
}


##  -----  Budget  -----  ##
resource "aws_budgets_budget" "this" {
  count = var.budget_limit_amount != null ? 1 : 0

  name         = "default-budget"
  budget_type  = "COST"
  limit_amount = var.budget_limit_amount
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
    subscriber_email_addresses = compact([var.email_address, var.central_budget_notification])
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "80"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = compact([var.email_address, var.central_budget_notification])
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "100"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = compact([var.email_address, var.central_budget_notification])
  }
}

##  -----  Vanta Auditing Service  -----  ##
module "vanta" {
  count  = var.enable_vanta_integration ? 1 : 0
  source = "../vanta"

  vanta_account_id                  = var.vanta_account_id
  vanta_external_id                 = var.vanta_external_id
  enable_identity_center_monitoring = true

}
