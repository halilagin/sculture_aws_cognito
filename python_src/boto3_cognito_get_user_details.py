# pylint: disable=all
import boto3
from botocore.exceptions import ClientError

client = boto3.client('cognito-idp', region_name='us-east-2')
# disable python linting warning
# pylint: disable-all

# pylint: disable=all

user_pool_id = "us-east-2_YDOLK0xD4"
username = 'halilagin'

# users_resp = client.list_users(
# 	UserPoolId=user_pool_id,
# 	AttributesToGet=['email']
# )
# print(users_resp)

try:
	cognito_response = client.admin_get_user(UserPoolId=user_pool_id, Username=username)

	print(cognito_response)
except ClientError as e:
	print(f'Error: {e}')

