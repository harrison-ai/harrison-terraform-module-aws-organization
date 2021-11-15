# Terraform AWS Organisation Member Account Baseline

A Terraform module which configures an opinionated Org CloudTrail.

The S3 bucket will be created in an account designated the "Audit" account - ALl other resources are in the master account.

Note that there is a lifecycle policy configured on the S3.  By default it is configured to:

Transition object to Infrequent Access after 90 days
Delete objects after 2555 days (7 years)

Both values are configurable

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_ebs_encryption_by_default.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default) | resource |
| [aws_s3_account_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_ids"></a> [account\_ids](#input\_account\_ids) | n/a | `map(any)` | n/a | yes |
| <a name="input_accounts"></a> [accounts](#input\_accounts) | n/a | `map(any)` | n/a | yes |
| <a name="input_central_budget_nofication"></a> [central\_budget\_nofication](#input\_central\_budget\_nofication) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | n/a | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | n/a | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
