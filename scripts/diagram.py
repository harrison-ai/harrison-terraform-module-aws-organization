from diagrams import Diagram
from diagrams.aws.management import (Organizations, OrganizationsAccount,
                                     OrganizationsOrganizationalUnit)
from diagrams.aws.security import IAMPermissions

with Diagram('AWS Organization',
             show=False,
             filename='aws-org',
             direction='TB'):

    org = Organizations('org')

    root_ou = OrganizationsOrganizationalUnit('Root')

    # top level OUs
    harrison = OrganizationsOrganizationalUnit('harrison')
    annalise = OrganizationsOrganizationalUnit('annalise')

    # child level OUs
    harrison_shared = OrganizationsOrganizationalUnit('shared')
    harrison_sandpit = OrganizationsOrganizationalUnit('sandpit')
    harrison_develop = OrganizationsOrganizationalUnit('develop')
    harrison_production = OrganizationsOrganizationalUnit('production')
    annalise_shared = OrganizationsOrganizationalUnit('shared')
    annalise_sandpit = OrganizationsOrganizationalUnit('sandpit')
    annalise_develop = OrganizationsOrganizationalUnit('develop')
    annalise_production = OrganizationsOrganizationalUnit('production')

    #  member accounts
    audit = OrganizationsAccount('audit')
    network = OrganizationsAccount('network')
    services = OrganizationsAccount('services')
    dev_one = OrganizationsAccount('person one')
    dev_two = OrganizationsAccount('person two')
    dev_three = OrganizationsAccount('person three')

    #  SCP's
    block_root_user = IAMPermissions('block-root-user')
    block_iam_users = IAMPermissions('block-iam-users')
    block_create_vpc = IAMPermissions('block-create-vpc')

    org >> root_ou
    root_ou >> harrison
    root_ou >> annalise

    block_root_user >> harrison
    block_iam_users >> harrison

    harrison >> harrison_sandpit
    harrison >> harrison_develop
    harrison >> harrison_production
    harrison >> harrison_shared

    annalise >> annalise_sandpit
    annalise >> annalise_develop
    annalise >> annalise_production
    annalise >> annalise_shared

    block_create_vpc >> harrison_sandpit

    harrison_shared >> audit
    harrison_shared >> network
    harrison_shared >> services
    harrison_sandpit >> dev_one
    harrison_sandpit >> dev_two
    harrison_sandpit >> dev_three
