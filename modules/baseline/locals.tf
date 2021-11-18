locals {
  account    = [for a in var.accounts : a if a.name == var.name][0]
  account_id = var.account_ids[var.name]
}
