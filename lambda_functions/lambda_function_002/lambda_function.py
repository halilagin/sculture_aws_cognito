import json
import requests
import db.dynamo.dao as dao

def lambda_handler(event, context):
    print("Received event: " + str(event))
    #data = {} #json.loads(event['body'])


    item = {
        'id': 2,
        'name': "halil",
        'title': 'Introduction to DynamoDB',
        'content': 'This is a blog post about how to use DynamoDB.',
        'tags': ['AWS', 'DynamoDB', 'Database']
    }
    dao.insert_item(item)

    response = {
           'statusCode': 200,
           'body': "dynamo db item inserted successfully.",
           'headers': {
               'Content-Type': 'application/json'
               }
           }
    return response


if __name__ == '__main__':
    print(lambda_handler({'body': '{}'}, None))
