# Terraform AWS Organisation Member Account Baseline

A Terraform module which applies a baseline configuration to Org Member Accounts


## Usage

```terraform
module "example" {
  source = "../modules/baseline"

  name                      = "member-account-name"
  region                    = "ap-southeast-2"
  profile                   = "my-named-profile"
  #  account ids are output from the organization module
  account_ids               = module.org.member_accounts
  accounts                  = local.member_accounts
  central_budget_nofication = "finance@example.com"
  project                   = "example"
  repo                      = "example"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.64 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.64 |
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subnetting"></a> [subnetting](#module\_subnetting) | ../cidr | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_ebs_encryption_by_default.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default) | resource |
| [aws_iam_account_password_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_s3_account_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block) | resource |
| [external_external.delete_default_vpc](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_ids"></a> [account\_ids](#input\_account\_ids) | Map of Organization Member Account ID's | `map(any)` | n/a | yes |
| <a name="input_accounts"></a> [accounts](#input\_accounts) | List of Organization Member Accounts | `list(any)` | n/a | yes |
| <a name="input_central_budget_nofication"></a> [central\_budget\_nofication](#input\_central\_budget\_nofication) | Central or Shared email address for Budget Notifications | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Member Account Name | `string` | n/a | yes |
| <a name="input_number_azs"></a> [number\_azs](#input\_number\_azs) | Number of AZ's in which to provision resources | `number` | `3` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS Shared Credentials Profile | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Designated project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Name of this current repository | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | `"main"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
