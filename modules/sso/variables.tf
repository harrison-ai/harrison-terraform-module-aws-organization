variable "managed_permission_sets" {
  type        = list(any)
  description = "List of the required Permission Sets that contain AWS Managed Policies"
}

variable "inline_permission_sets" {
  type        = list(any)
  description = "List of the required Permission Sets that are comprised of inline IAM Policies"
}

variable "sso_groups" {
  type        = list(any)
  default     = []
  description = "List of the Groups as obtained from the Identity Provider"
}

variable "sso_users" {
  type        = list(any)
  default     = []
  description = "List of the Users as obtained from the Identity Provider"
}

variable "sandbox_enabled_users" {
  type        = list(string)
  default     = []
  description = "List of users who have personal sandbox accounts"
}
