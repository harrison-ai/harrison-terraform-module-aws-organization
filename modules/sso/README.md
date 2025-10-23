# Terraform AWS SSO

A Terraform module which configures AWS Single Sign On. Note that there are some pre-requisite manual steps to be configured in the Console before applying any Terraform configuration.

Any supported Identity Provider can be configured, however these instructions will refer to Azure AD.

## Pre-requisite Configuration

Note that the following steps are completed in the AWS Console and the Azure AD Portal

Complete in Azure AD:

- Locate and install the AWS Single Sign-On app as an Enterprise Application from the App Gallery
- Obtain the following settings:
  - IdP sign-in URL / Metadata URL. This will be in the format: https://login.microsoftonline.com/<tenant-id>/saml2
  - IdP issuer URL. This will be in the format: https://sts.windows.net/<tenant-id>/
  - Certificate in raw format
- Assign the relevant groups and users to the Enterprise App.

Complete in AWS Console:

- Navigate to AWS SSO and enable SSO (this can only be done via the Console)
- Select "Choose your identity source" and select "External Identity Provider"
- Configure the Identity Provider using the details obtained from Azure AD.
- Note the SCIM endpoint and Access Token and pass back to Azure AD.
- Download the identity file and pass back to Azure AD.

- Ensure Auto Provisioning is enabled in Azure AD and ensure you can see the groups/users assigned to the App in the AWS Console | AWS SSO | Groups

## Requirements

AWS SSO should be configured in the Organization Master account. See also the section below regarding Delegated SSO Admin

AWS SSO should be included in the Organization Service Access Principals

## Delegated SSO Administration

If Delegated SSO Administation is enabled in this Organisation, you will need to provide this module with a list of member account name to ID mappings as the data source used to obtain this list will not work in this scenario. Note that you will also need to enable the `delegated_sso_admin` attribute in the module. See the examples directory.

```terraform
accounts_list = [
  {
    name = "account-one",
    id = "123456789012"
  },
  {
    name = "account-two",
    id = "123456789012"
  }
]
```

## Terraform Configuration

As an overview:

- Azure AD Groups/Users appear automatically in AWS SSO | Groups / Users.
- **Permission Sets** are created, to which IAM Policies are attached.
- A **Permission Set** is mapped to a Group and to an Account(s).

## Example Data Structures

See the examples directory for a complete example

```terraform
sso_groups = [
  {
    name =   "master-admins"
    accounts = ["org-master-account"]
    permission_set = "AdministratorAccess"
  }
]
```

```terraform
permission_sets = [
  {
    name = "AdministratorAccess"
    description = "Full Administrator Access"
    attached_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  }
]
```

## References

https://docs.aws.amazon.com/singlesignon/latest/userguide/azure-ad-idp.html

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssoadmin_account_assignment.groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_account_assignment.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_managed_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_ssoadmin_permissions_boundary_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permissions_boundary_attachment) | resource |
| [aws_identitystore_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_ssoadmin_instances.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts_list"></a> [accounts\_list](#input\_accounts\_list) | A list of Member Account Name and ID mappings, required if Delegated SSO Admin is in use | `list(any)` | `[]` | no |
| <a name="input_delegated_sso_admin"></a> [delegated\_sso\_admin](#input\_delegated\_sso\_admin) | Is Delegated SSO Admin configured in this Organisation? | `bool` | `false` | no |
| <a name="input_inline_permission_sets"></a> [inline\_permission\_sets](#input\_inline\_permission\_sets) | List of the required Permission Sets that are comprised of inline IAM Policies | <pre>list(object({<br/>    name             = string<br/>    description      = string<br/>    inline_policy    = string<br/>    session_duration = optional(string, "PT12H")<br/>    permissions_boundary = optional(object({<br/>      managed_policy_arn = optional(string)<br/>      customer_managed_policy_reference = optional(object({<br/>        name = string<br/>        path = optional(string, "/")<br/>      }))<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_managed_permission_sets"></a> [managed\_permission\_sets](#input\_managed\_permission\_sets) | List of the required Permission Sets that contain AWS Managed Policies | <pre>list(object({<br/>    name              = string<br/>    description       = string<br/>    attached_policies = list(string)<br/>    session_duration  = optional(string, "PT12H")<br/>    permissions_boundary = optional(object({<br/>      managed_policy_arn = optional(string)<br/>      customer_managed_policy_reference = optional(object({<br/>        name = string<br/>        path = optional(string, "/")<br/>      }))<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_sandbox_enabled_users"></a> [sandbox\_enabled\_users](#input\_sandbox\_enabled\_users) | List of users who have personal sandbox accounts | `list(string)` | `[]` | no |
| <a name="input_sso_groups"></a> [sso\_groups](#input\_sso\_groups) | List of the Groups as obtained from the Identity Provider | `list(any)` | `[]` | no |
| <a name="input_sso_users"></a> [sso\_users](#input\_sso\_users) | List of the Users as obtained from the Identity Provider | `list(any)` | `[]` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
