import boto3

open_rules = '0.0.0.0/0'

exFromPort = 'FromPort'
exToPort = 'ToPort'
region = 'us-east-2'


sns_client = boto3.client('sns', region_name='us-east-2')

def publish_message():
    response = sns_client.publish(
        TopicArn='arn:aws:sns:us-east-2:613036180535:h-topic',
        Message="SG com ID (sg-059050c0d9c51566a) ESTA EXPOSTO PARA O MUNDO",
        Subject="SG DO CLUSTER",
        )

def publish_message_sg():
    response = sns_client.publish(
        TopicArn='arn:aws:sns:us-east-2:613036180535:h-topic',
        Message="SG COM ID (sg-0c800cd973474591c) ESTA EXPOSTO PARA O MUNDO",
        Subject="SG DO CLUSTER",
        )


client = boto3.client('ec2', region_name='us-east-2')
def lambda_handler(event, context):
    response = client.describe_security_groups(GroupIds=['sg-059050c0d9c51566a'])

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

    sg2 = client.describe_security_groups(GroupIds=['sg-0c800cd973474591c'])

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