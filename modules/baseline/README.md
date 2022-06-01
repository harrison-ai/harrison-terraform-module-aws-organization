# Terraform AWS Organisation Member Account Baseline

A Terraform module which applies a baseline configuration to Org Member Accounts


## Usage

```terraform
module "example" {
  source = "../modules/baseline"

  config                      = local.shared_account_config["member-account-name"]
  central_budget_notification = "finance@example.com"
  project                     = "example"
  repo                        = "example"
  profile                     = "my-named-profile"
  region                      = "ap-southeast-2"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

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
| <a name="input_central_budget_notification"></a> [central\_budget\_notification](#input\_central\_budget\_notification) | Central or Shared email address for Budget Notifications | `string` | `""` | no |
| <a name="input_config"></a> [config](#input\_config) | Map of configuration items | `map(any)` | n/a | yes |
| <a name="input_create_s3_account_public_access_block"></a> [create\_s3\_account\_public\_access\_block](#input\_create\_s3\_account\_public\_access\_block) | Create the account level S3 Public Access Block | `bool` | `true` | no |
| <a name="input_min_iam_password_length"></a> [min\_iam\_password\_length](#input\_min\_iam\_password\_length) | Minimum length of IAM password | `number` | `64` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS Shared Credentials Profile | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Designated project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Name of this current repository | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
