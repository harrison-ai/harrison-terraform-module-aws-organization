# Terraform AWS Organisation Member Account Baseline

A Terraform module which applies a baseline configuration to Org Member Accounts

## Usage

```terraform

provider "aws" {
  alias               = "example"
  allowed_account_ids = ["012345678912"]
  assume_role {
    role_arn = "arn:aws:iam::012345678912:role/OrganizationAccountAccessRole"
  }
}

module "example" {
  source = "../modules/baseline"

  providers = {
    aws = aws.example
  }

  allowed_regions                       = ["ap-southeast-2", "us-west-2, "us-east-1"]
  aws_account_id                        = "012345678912"
  budget_limit_amount                   = 200
  central_budget_notification           = "foo@example.com"
  create_s3_account_public_access_block = true
  email_address                         = "example@harrison.ai"
}
```

## Provider Configuration

As some operations performed by this module may be blocked by SCP, it is suggested to use the `OrganizationAccountAccessRole` in the appropriate account to perform these actions.

The calling stack should configure a provider alias for every member account in the organisation.  It is suggested to use a Terraform wrapper such as Terramate to assist with the generation of this boilerplate code.

This module leverages the "Enhanced Region Support" feature of the Terraform AWS v6 provider to create the `aws_ebs_encryption_by_default` resource in every enabled region in the AWS Org.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vanta"></a> [vanta](#module\_vanta) | ../vanta | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_ebs_encryption_by_default.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default) | resource |
| [aws_iam_account_password_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_s3_account_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_regions"></a> [allowed\_regions](#input\_allowed\_regions) | n/a | `list(string)` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | n/a | `string` | n/a | yes |
| <a name="input_budget_limit_amount"></a> [budget\_limit\_amount](#input\_budget\_limit\_amount) | n/a | `number` | n/a | yes |
| <a name="input_central_budget_notification"></a> [central\_budget\_notification](#input\_central\_budget\_notification) | Central or Shared email address for Budget Notifications | `string` | `""` | no |
| <a name="input_create_s3_account_public_access_block"></a> [create\_s3\_account\_public\_access\_block](#input\_create\_s3\_account\_public\_access\_block) | Create the account level S3 Public Access Block | `bool` | `true` | no |
| <a name="input_email_address"></a> [email\_address](#input\_email\_address) | n/a | `string` | n/a | yes |
| <a name="input_enable_vanta_integration"></a> [enable\_vanta\_integration](#input\_enable\_vanta\_integration) | Enable Vanta integration. | `bool` | `false` | no |
| <a name="input_min_iam_password_length"></a> [min\_iam\_password\_length](#input\_min\_iam\_password\_length) | Minimum length of IAM password | `number` | `64` | no |
| <a name="input_vanta_account_id"></a> [vanta\_account\_id](#input\_vanta\_account\_id) | Vanta Account ID. Can be retrieved from the portal during the AWS account set up. | `string` | `null` | no |
| <a name="input_vanta_external_id"></a> [vanta\_external\_id](#input\_vanta\_external\_id) | Vanta External ID. Can be retrieved from the portal during the AWS account set up. | `string` | `null` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
