import json
import os
import sys
import time

import boto3

'''
This script takes input from stdin from the external.delete_default_vpc resource.
Expected input is a json object as follows:
{"account_id": "123456789012", "region": "ap-southeast-2"}
'''


def assume_role(region, session, role, duration=3600):
    '''Assume an IAM Role, returning the temp credentials'''

    sts = session.client('sts',
                         endpoint_url=f'https://sts.{region}.amazonaws.com')
    resp = sts.assume_role(RoleArn=role,
                           RoleSessionName='baseline',
                           DurationSeconds=duration)

    credentials = {
        'aws_access_key_id': resp['Credentials']['AccessKeyId'],
        'aws_secret_access_key': resp['Credentials']['SecretAccessKey'],
        'aws_session_token': resp['Credentials']['SessionToken']
    }

    return credentials


def get_vpc_id(ec2):
    ''' Return the default VPC ID'''

    resp = ec2.describe_vpcs(Filters=[{
        'Name': 'is-default',
        'Values': ['true']
    }])

    if len(resp['Vpcs']) > 0:
        vpc_id = resp['Vpcs'][0]['VpcId']

        return vpc_id


def get_igw(ec2, vpc_id):
    ''' Return the Internet Gateway ID of the IGW attached to the default VPC'''

    resp = ec2.describe_internet_gateways(Filters=[{
        'Name': 'attachment.vpc-id',
        'Values': [vpc_id]
    }])

    if len(resp['InternetGateways']) > 0:
        igw = resp['InternetGateways'][0]['InternetGatewayId']

        return igw


def get_subnets(ec2, vpc_id):
    ''' Return the Subnet ID's of the subnets in the default VPC'''

    resp = ec2.describe_subnets(Filters=[{
        'Name': 'vpc-id',
        'Values': [vpc_id]
    }])

    if len(resp['Subnets']) > 0:
        subnets = []
        for subnet in resp['Subnets']:
            subnets.append(subnet['SubnetId'])

        return subnets


def main():

    input = [x.strip() for x in sys.stdin][0]
    account_id = json.loads(input)['account_id']
    region = json.loads(input)['region']

    iam_role = f'arn:aws:iam::{account_id}:role/OrganizationAccountAccessRole'

    session = boto3.session.Session(region_name=region)
    credentials = assume_role(region, session, iam_role)
    ec2 = session.client('ec2', **credentials)

    vpc_id = get_vpc_id(ec2)

    if vpc_id:

        igw = get_igw(ec2, vpc_id)

        if igw is not None:

            ec2.detach_internet_gateway(InternetGatewayId=igw, VpcId=vpc_id)
            time.sleep(2)
            ec2.delete_internet_gateway(InternetGatewayId=igw)

        subnets = get_subnets(ec2, vpc_id)

        if subnets is not None:

            for subnet in subnets:
                ec2.delete_subnet(SubnetId=subnet)

        ec2.delete_vpc(VpcId=vpc_id)

    print(json.dumps({'status': 'ok'}))


if __name__ == "__main__":
    main()
