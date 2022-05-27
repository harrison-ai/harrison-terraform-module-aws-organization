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
  type    = bool
  default = true
}
