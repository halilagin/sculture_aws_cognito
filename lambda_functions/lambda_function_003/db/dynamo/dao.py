import boto3
from botocore.exceptions import ClientError

def get_item(key):
    # Initialize a DynamoDB resource
    dynamodb = boto3.resource('dynamodb', region_name='us-east-2')
    table = dynamodb.Table('dyn_simple_table')
    
    print ("key", key)
    # Get the item
    try:
        response = table.get_item(Key=key)
        item = response['Item']
        print('Item found:', item)
        return item
    except ClientError as e:
        print('Failed to get item:', e.response['Error']['Message'])
        return None



def insert_item(item):
    # Initialize a DynamoDB resource
    dynamodb = boto3.resource('dynamodb', region_name='us-east-2')
    table = dynamodb.Table('dyn_simple_table')
    

    # Insert the item
    try:
        if item is None:
            raise ValueError('Item is None')
        response = table.put_item(Item=item)
        print('Item inserted successfully:', response)
    except ClientError as e:
        print('Failed to insert item:', e.response['Error']['Message'])
