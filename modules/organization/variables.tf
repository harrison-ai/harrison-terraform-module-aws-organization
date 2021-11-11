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
