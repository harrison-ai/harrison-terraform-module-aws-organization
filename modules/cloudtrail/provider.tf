terraform {

  required_version = ">= 1.0.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64"
    }
  }
}

provider "aws" {
  alias = "audit"

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"
  }

  default_tags {
    tags = {
      # Environment = var.env_name
      Project = var.project
      Repo    = var.repo
    }
  }
}
