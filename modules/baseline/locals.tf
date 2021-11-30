locals {
  account    = [for a in var.accounts : a if a.name == var.name][0]
  account_id = var.account_ids[var.name]

  # map of AZ's from which to slice up for required number of AZs
  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
    "${var.region}d",
    "${var.region}e"
  ]
}
