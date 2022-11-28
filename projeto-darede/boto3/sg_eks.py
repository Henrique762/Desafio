import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='us-east-1')

    try:
        response = ec2.describe_security_groups(GroupIds=['sg-02d27ddb102f7336c'])
        print(f'CIDR permissions {ec2.ip-permission.cidr}')
    
    except ClientError as e:
        print(e)