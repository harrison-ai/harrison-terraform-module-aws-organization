variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "allowed_regions" {
  type        = list(string)
  description = "A list of enabled AWS regions"
}

variable "budget_limit_amount" {
  type        = number
  description = "Budget amount for member account"
}

variable "central_budget_notification" {
  type        = string
  default     = ""
  description = "Central or Shared email address for Budget Notifications"
}

variable "email_address" {
  type    = string
  default = "Email address associated with account root user"
}

variable "create_s3_account_public_access_block" {
  type        = bool
  default     = true
  description = "Create the account level S3 Public Access Block"
}

variable "min_iam_password_length" {
  type        = number
  default     = 64
  description = "Minimum length of IAM password"
}

variable "enable_vanta_integration" {
  type        = bool
  default     = false
  description = "Enable Vanta integration."
}

variable "vanta_account_id" {
  type        = string
  default     = null
  description = "Vanta Account ID. Can be retrieved from the portal during the AWS account set up."
  sensitive   = true
}

variable "vanta_external_id" {
  type        = string
  default     = null
  description = "Vanta External ID. Can be retrieved from the portal during the AWS account set up."
  sensitive   = true
}
