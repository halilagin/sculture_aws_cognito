import boto3
import hmac, base64, hashlib




def get_access_token(user_pool_id, client_id, username, password, region):
    client = boto3.client('cognito-idp', region_name=region)

    try:
        response = client.initiate_auth(
            ClientMetadata={
                "UserPoolId":user_pool_id,
                },
            ClientId=client_id,
            #AuthFlow='ADMIN_NO_SRP_AUTH',
            AuthFlow="USER_PASSWORD_AUTH",
            AuthParameters={
                'USERNAME': username,
                'PASSWORD': password,
            }
        )
        return response['AuthenticationResult']['AccessToken']
    except client.exceptions.NotAuthorizedException as e:
        print (str(e))
        print("The username or password is incorrect.")
    except client.exceptions.UserNotFoundException:
        print("The username does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage:
user_pool_id = 'us-east-2_7MTWVQqwy'
client_id = 'mehiu6nkd9eshibihg8v4mm7j'
username = 'halilagin'
password = 'YourTempPassword2024!!'
region = 'us-east-2'
access_token = get_access_token(user_pool_id, client_id, username, password, region)
print("Access Token:", access_token)
