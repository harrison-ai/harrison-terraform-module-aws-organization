variable "permission_sets" {
  type = list(any)
  description = "List of the required Permission Sets"
}

variable "sso_groups" {
  type = list(any)
  description = "List of the Groups as obtained from the Identity Provider"
}
