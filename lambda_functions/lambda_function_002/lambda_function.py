import json
import requests
import db.dynamo.dao as dao

from fastapi import FastAPI, Request
from mangum import Mangum

app = FastAPI()

"""
@app.middleware("http")
async def set_root_path_for_api_gateway(request: Request, call_next):
  root_path = request.scope["root_path"]
  if root_path:
    # Assume set correctly in this case
    app.root_path = root_path

  else:
    # fetch from AWS requestContext
    if "aws.event" in request.scope:
      context = request.scope["aws.event"]["requestContext"]

      if "customDomain" not in context:
        # Only works for stage deployments currently
        root_path = f"/{context['stage']}"

        if request.scope["path"].startswith(root_path):
          request.scope["path"] = request.scope["path"][len(root_path) :]
        request.scope["root_path"] = root_path
        app.root_path = root_path

        # NOT IMPLEMENTED FOR customDomain
        # root_path = f"/{context['customDomain']['basePathMatched']}"

  response = await call_next(request)
  return response
"""

@app.post("/lambda_function_002")
def get_root():
  print("Received event: " )
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



# Create a Mangum handler
#handler = Mangum(app=app, lifespan="off", api_gateway_base_path='/stage')
handler = Mangum(app=app)


if __name__ == '__main__':
  print(handler({'body': '{}'}, None))
