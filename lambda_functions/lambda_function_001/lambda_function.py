import json
def lambda_handler(event, context):
    # Print the received event to the CloudWatch Logs
    print("Received event: " + str(event))
    data = json.loads(event['body'])

    # Example of accessing event data (e.g., from API Gateway or direct invocation)
    name = data.get('name', 'World')

    # Create a response
    response = {
        'statusCode': 200,
        'body': f'Hello {name}!',
        'headers': {
            'Content-Type': 'application/json'
        }
    }

    # Return the response
    return response
