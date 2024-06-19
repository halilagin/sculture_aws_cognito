import json
import requests
import db.dynamo.dao as dao
import random 
from decimal import *

class DecimalEncoder(json.JSONEncoder):
	def default(self, obj):
		if isinstance(obj, Decimal):
			return str(obj)
		return json.JSONEncoder.default(self, obj)


def insert_items(items):

    if items is None or len(items) == 0:
        items = [ {
            'id': random.randint(1, 100000),
            'name': "halil",
            'title': 'Introduction to DynamoDB',
            'content': 'This is a blog post about how to use DynamoDB.',
            'tags': ['AWS', 'DynamoDB', 'Database']
        }]

    for item in items:
        dao.insert_item(item)


def get_item(record_key):
    return dao.get_item(record_key)



def handler(event, context):
    print("Received event: " + str(event))
    data = json.loads(event['body'])


    if 'action' in data:
        action = data['action']
        if action == 'insert':
            insert_items(data['items'])
        elif action == 'get':
            item = get_item(data['record_key'])
            response = {
                   'statusCode': 200,
                   'body': json.dumps(item, cls=DecimalEncoder),
                   'headers': {
                       'Content-Type': 'application/json'
                       }
                   }
            print(response)
            return response
        else:
            response = {
                'statusCode': 400,
                'body': "Unsupported action " + action,
                'headers': {
                    'Content-Type': 'application/json'
                }
            }
            return response



    response = {
           'statusCode': 200,
           'body': f"{data['action']} action is successful",
           'headers': {
               'Content-Type': 'application/json'
               }
           }
    return response


if __name__ == '__main__':
    print(handler({'body': '{}'}, None))
