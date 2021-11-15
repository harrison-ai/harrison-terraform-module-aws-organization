variable "name" {
  type = string
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "project" {
  type = string
}

variable "repo" {
  type = string
}

variable "accounts" {
  type = map(any)
}

variable "account_ids" {
  type = map(any)
}

variable "central_budget_nofication" {
  type = string
}
