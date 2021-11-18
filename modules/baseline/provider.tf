terraform {

  required_version = ">= 1.0.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.1"
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
    role_arn = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"
  }
}
