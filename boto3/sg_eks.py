import boto3

open_rules = '0.0.0.0/0'

exFromPort = 'FromPort'
exToPort = 'ToPort'
region = 'us-east-2'


sns_client = boto3.client('sns', region_name='us-east-1')

def publish_message():
    response = sns_client.publish(
        TopicArn='arn:aws:sns:us-east-1:260646838877:Sgs_Emails',
        Message="SG com ID (sg-050c495bdc243c7b6) ESTA EXPOSTO PARA O MUNDO",
        Subject="SG DO CLUSTER",
        )

def publish_message_sg():
    response = sns_client.publish(
        TopicArn='arn:aws:sns:us-east-1:260646838877:Sgs_Emails',
        Message="SG COM ID (sg-069fcfaf72c6b00e7) ESTA EXPOSTO PARA O MUNDO",
        Subject="SG DO NODEGROUP",
        )


client = boto3.client('ec2', region_name='us-east-1')

def lambda_handler(event, context):
    response = client.describe_security_groups(GroupIds=['sg-050c495bdc243c7b6'])

    for sg in response["SecurityGroups"]:
        # grab these variables so that they're sent to the revoke security group access
        groupId = sg['GroupId']
        groupName = sg['GroupName']

        for ip in sg['IpPermissions']:
            # there has to be an exception for security groups that don't have ports.
            if exFromPort in ip:
                fromPort = ip['FromPort']
                ipProtocol = ip['IpProtocol']
                toPort = ip['ToPort']
                for cidr in ip['IpRanges']:
                    # identifying which rules contain a open_rules IP range
                    if cidr['CidrIp'] == open_rules:
                        publish_message()

    sg2 = client.describe_security_groups(GroupIds=['sg-069fcfaf72c6b00e7'])

    for sg in sg2["SecurityGroups"]:
        # grab these variables so that they're sent to the revoke security group access
        groupId = sg['GroupId']
        groupName = sg['GroupName']

        for ip in sg['IpPermissions']:
            # there has to be an exception for security groups that don't have ports.
            if exFromPort in ip:
                fromPort = ip['FromPort']
                ipProtocol = ip['IpProtocol']
                toPort = ip['ToPort']
                for cidr in ip['IpRanges']:
                    # identifying which rules contain a open_rules IP range
                    if cidr['CidrIp'] == open_rules:
                        publish_message_sg()