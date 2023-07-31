# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.7]

- Create the Vanta integration module and incorperate it into the `baseline` and `organization` module.


## [0.1.6]

- Update deprecated filter on `aws_identitystore_user` and `aws_identitystore_group` data sources in the `sso` module.

## [0.1.5]

- Add a boolean `destroy` flag into the `baseline` module.

## [0.1.4]

- Added the `close_on_deletion` argument to the `organisation.aws_organizations_account.this` resource.  See also this AWS [blog post](https://aws.amazon.com/blogs/mt/aws-organizations-now-provides-a-simple-scalable-and-more-secure-way-to-close-your-member-accounts/)

- Ability to specify tags for AWS Org member accounts

## [0.1.3]

- Allow configuring the `session_duration` in SSO Permission Sets

## [0.1.2]

- Enable the use of Delegated SSO Administration

## [0.1.1]

- Released as an Open Source module

## [0.1.0]

- Initial version
