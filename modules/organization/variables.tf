variable "aws_service_access_principals" {
  type        = list(any)
  description = "ist of AWS service principal names for which you want to enable integration with your organization"
}

variable "enabled_policy_types" {
  type        = list(any)
  description = "List of Organizations policy types to enable in the Organization Root"
}

variable "accounts" {
  type        = list(any)
  default     = []
  description = "List of member accounts to be added to the organization"
}

variable "top_level_org_units" {
  type        = list(any)
  default     = []
  description = "List of Organizational Units to be created directly under the Root OU"
}

variable "child_org_units" {
  type        = list(any)
  default     = []
  description = "List of Organizational Units to be created directly under a Top Level Org Unit"
}

variable "service_control_policies" {
  type        = list(any)
  default     = []
  description = "List of Service Control Policies (SCP's)"
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
