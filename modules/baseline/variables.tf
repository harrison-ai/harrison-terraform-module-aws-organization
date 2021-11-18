variable "name" {
  type        = string
  description = "Member Account Name"
}

variable "profile" {
  type        = string
  description = "AWS Shared Credentials Profile"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "project" {
  type        = string
  description = "Designated project name"
}

variable "repo" {
  type        = string
  description = "Name of this current repository"
}

variable "accounts" {
  type        = list(any)
  description = "List of Organization Member Accounts"
}

variable "account_ids" {
  type        = map(any)
  description = "Map of Organization Member Account ID's"
}

variable "central_budget_nofication" {
  type        = string
  default     = null
  description = "Central or Shared email address for Budget Notifications"
}
