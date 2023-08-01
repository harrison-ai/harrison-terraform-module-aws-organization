terraform {

  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

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
    role_arn = "arn:aws:iam::${var.config.account_id}:role/OrganizationAccountAccessRole"
  }
}
