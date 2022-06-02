# Terraform AWS Organisation

A Terraform module which configures an AWS Organisation.  Creating an AWS Organisation is a fairly complex task, with some manual steps as outlined below.

## Requirements for setting up an AWS Organisation

- An email address that hasn't been used for any other AWS Account.  Ideally this will be a Distribution Group or Shared Mailbox address  (see email schema notes)
- Billing or Physical Address
- Valid Credit Card
- Mobile phone for text verification


## Email address schema

You will require a unique email address for each member account in the Organisation.  It is suggested that a consistent format is planned out beforehand.

By way of example:

| Account                   | Email                     |
| ---                       | ---                       |
| (org-name)-master         | aws.master@               |
| (org-name)-network        | aws.network@              |
| (org-name)-audit          | aws.audit@                |
| Developer Sandpit Account | user email address        |


## Terraform Composition Stacks / State

It is suggested that at least two Terraform composition stacks or states are created in the repository from which this is deployed:

| Stack            | Purpose                                          | Notes                                                              |
| ---              | ---                                              | ---                                                                |
| tf-state-buckets | Deploy the S3 state bucket in the master account | Note that the terraform state file will be local                   |
| org              | Deploy the AWS Organisation                      | Configure the Terraform backend to use the S3 bucket just deployed |


## Organizational Units

This module supports the creation of up to two levels of Organizational Units beneath the `Root` OU.  These are configured in the following two Input Variables:

- `top_level_org_units`
- `child_org_units`


## Service Control Policies (SCP's)

This module supports the creation and attachment of any number of SCP's, attached to any Organizational Unit.  SCP policy documents should be supplied as `aws_iam_policy_document` Data Sources.  These will be provided to this module as an attribute of the `service_control_policies` Input Variable.  The SCP's can be attached to any OU by providing the OU name/uuid.

## Example Diagram

![AWS Org](aws-org.png)

## Procedure

### Initial Setup

- Plan out the account naming scheme
- Manually create the account designated the master account in the AWS Console
- Log into the account and create an IAM User called `org-setup`, configured as follows:  (This user can later be deleted once SSO has been configured)
    - Programatic use only
    - Attach the AWS Managed `AdministratorAccess` IAM Policy
    - Download the static credentials and configure an appropriate Named profile

- Using the `harrison-ai/harrison-terraform-module-tf-state-buckets` module, create a S3 bucket for Terraform state in the master account.  As suggested above, consider a dedicated Terraform composition or state for this

- Create a Terraform Stack or State for the AWS Org to be deployed from this module
- Use the S3 bucket created above as the backend
- NB:  Do not add any member accounts to the Org at this stage.
- Import the Organization into the stack.

See the Data Structures section for the expected Input Variable formats.


## Input Variables

> Certain Variables require uuid values as its possible to have multiple OU's with the same name.
> Generate them with the `make uuid` command


### Service Control Policies

```terraform
service_control_policies = [
  {
    name        = "example"
    description = "Example Description"
    policy      = data.aws_iam_policy_document.example.json
  }
]
```

### Top Level Organizational Units

```terraform
top_level_org_units = [
  {
    name          = "harrison"
    uuid          = "a4856923-00f2-a13e-9148-1238136a082c"
    attached_scps = ["example"]
  }
]
```

### Child Organization Units

```terraform
child_org_units = [
  {
    name          = "sandpit"
    uuid          = "5d41dd0c-561a-eab4-ad53-4da7753a89b7"
    attached_scps = []
    parent = {
      name = "harrison"
      uuid = "a4856923-00f2-a13e-9148-1238136a082c"
    }
  }
]
```

Please Note:
parent.name is the name of the parent OU
parent.uuid is the uuid value of the parent OU


### Member Accounts

Add Member Accounts by adding them to the `member_accounts` local variable.  Note the parent name and uuid values to place the account into a specific Organizational Unit.  Set these values to null to place the account in the org root.

```terraform
member_accounts = [
  {
    name = "prod-workloads"
    email = "aws.prod.workloads@example.com"
    iam_user_access_to_billing = "ALLOW"
    enable_budget = true
    budget_limit_amount = "200"
    parent = {
      name = "production"
      uuid = "5d41dd0c-561a-eab4-ad53-4da7753a89b6"
    }
  },
  {
    name = "dev-workloads"
    email = "aws.dev.workloads@example.com"
    iam_user_access_to_billing = "ALLOW"
    enable_budget = true
    budget_limit_amount = "200"
    parent = {
      name = null
      uuid = null
    }
  }
]
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
| [aws_organizations_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.child_org_units](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.top_level_org_units](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts"></a> [accounts](#input\_accounts) | List of member accounts to be added to the organization | `list(any)` | `[]` | no |
| <a name="input_aws_service_access_principals"></a> [aws\_service\_access\_principals](#input\_aws\_service\_access\_principals) | ist of AWS service principal names for which you want to enable integration with your organization | `list(any)` | n/a | yes |
| <a name="input_child_org_units"></a> [child\_org\_units](#input\_child\_org\_units) | List of Organizational Units to be created directly under a Top Level Org Unit | `list(any)` | `[]` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | List of Organizations policy types to enable in the Organization Root | `list(any)` | n/a | yes |
| <a name="input_service_control_policies"></a> [service\_control\_policies](#input\_service\_control\_policies) | List of Service Control Policies (SCP's) | `list(any)` | `[]` | no |
| <a name="input_top_level_org_units"></a> [top\_level\_org\_units](#input\_top\_level\_org\_units) | List of Organizational Units to be created directly under the Root OU | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_member_accounts"></a> [member\_accounts](#output\_member\_accounts) | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
