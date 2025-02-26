variable "managed_permission_sets" {
  type = list(object({
    name              = string
    description       = string
    attached_policies = list(string)
    session_duration  = optional(string, "PT12H")
    permissions_boundary = optional(object({
      managed_policy_arn = optional(string)
      customer_managed_policy_reference = optional(object({
        name = string
        path = optional(string, "/")
      }))
    }))
  }))
  description = "List of the required Permission Sets that contain AWS Managed Policies"

  validation {
    condition = alltrue([
      for ps in var.managed_permission_sets :
      ps.permissions_boundary == null ||
      (ps.permissions_boundary.managed_policy_arn != null) !=
      (ps.permissions_boundary.customer_managed_policy_reference != null)
    ])
    error_message = "When permissions_boundary is set, exactly one of managed_policy_arn or customer_managed_policy_reference must be provided."
  }
}

variable "inline_permission_sets" {
  type = list(object({
    name             = string
    description      = string
    inline_policy    = string
    session_duration = optional(string)
    permissions_boundary = optional(object({
      managed_policy_arn = optional(string)
      customer_managed_policy_reference = optional(object({
        name = string
        path = optional(string, "/")
      }))
    }))
  }))
  description = "List of the required Permission Sets that are comprised of inline IAM Policies"

  validation {
    condition = alltrue([
      for ps in var.inline_permission_sets :
      ps.permissions_boundary == null ||
      (ps.permissions_boundary.managed_policy_arn != null) !=
      (ps.permissions_boundary.customer_managed_policy_reference != null)
    ])
    error_message = "When permissions_boundary is set, exactly one of managed_policy_arn or customer_managed_policy_reference must be provided."
  }
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

variable "delegated_sso_admin" {
  type        = bool
  default     = false
  description = "Is Delegated SSO Admin configured in this Organisation?"
}

variable "accounts_list" {
  type        = list(any)
  default     = []
  description = "A list of Member Account Name and ID mappings, required if Delegated SSO Admin is in use"
}
