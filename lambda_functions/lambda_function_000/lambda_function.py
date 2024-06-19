import json
import requests
def handler(event, context):
    # Print the received event to the CloudWatch Logs
    print("Received event: " + str(event))
    data = {} #json.loads(event['body'])

    # Example of accessing event data (e.g., from API Gateway or direct invocation)
    name = data.get('name', 'World')

    # Create a response

    body = {'message':f'Hello {name}!', 'ifconfigme': json.dumps(requests.get('http://ifconfig.me').content.decode())}
    response = {
        'statusCode': 200,
        'body': json.dumps(body),
        'headers': {
            'Content-Type': 'application/json'
        }
    }

    # Return the response
    print("""Response: """ + json.dumps(response) )
    return response


if __name__ == '__main__':
    print(handler({'body': '{}'}, None))
