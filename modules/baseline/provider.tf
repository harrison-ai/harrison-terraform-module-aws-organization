provider "aws" {

  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      Project = var.project
      Repo    = var.repo
    }
  }

  assume_role {
    role_arn = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"
  }
}
