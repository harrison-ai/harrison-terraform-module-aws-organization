# Terraform Vanta

A Terraform module which configures an AWS Organisation for Vanta integration.

<!-- BEGIN_TF_DOCS -->
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
| [aws_iam_policy.vanta_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.vanta_auditor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.vanta_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vanta_security_audit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.vanta_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vanta_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_identity_center_monitoring"></a> [enable\_identity\_center\_monitoring](#input\_enable\_identity\_center\_monitoring) | Enable IAM Identity Center scanning. | `bool` | `false` | no |
| <a name="input_vanta_account_id"></a> [vanta\_account\_id](#input\_vanta\_account\_id) | Vanta Account ID. Can be retrieved from the portal during the AWS account set up. | `string` | `null` | no |
| <a name="input_vanta_external_id"></a> [vanta\_external\_id](#input\_vanta\_external\_id) | Vanta External ID. Can be retrieved from the portal during the AWS account set up. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
