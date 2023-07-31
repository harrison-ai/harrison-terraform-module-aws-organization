variable "central_budget_notification" {
  type        = string
  default     = ""
  description = "Central or Shared email address for Budget Notifications"
}

variable "config" {
  type        = map(any)
  description = "Map of configuration items"
}

variable "profile" {
  type        = string
  description = "AWS Shared Credentials Profile"
}

variable "project" {
  type        = string
  description = "Designated project name"
}

variable "region" {
  type = string
}

variable "repo" {
  type        = string
  description = "Name of this current repository"
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
  description = "Enables vanta IAM integration if set to true. See https://help.vanta.com/hc/en-us/articles/4411799148692-Connecting-Vanta-AWS-account"
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

variable "destroy" {
  type        = bool
  default     = false
  description = "Flag to enable deletion of resources where the provider is embedded into the module"
}
