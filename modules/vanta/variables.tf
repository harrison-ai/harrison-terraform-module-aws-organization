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

variable "enable_identity_center_monitoring" {
  type        = bool
  default     = false
  description = "Enable IAM Identity Center scanning."
}
