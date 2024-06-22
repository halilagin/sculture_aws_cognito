import uvicorn
import json
import requests
#import db.dynamo.dao as dao

from fastapi import FastAPI, Request
from mangum import Mangum
from fastapi import APIRouter, HTTPException
from starlette.middleware.cors import CORSMiddleware
from starlette.routing import Mount


app = FastAPI()

#app.add_middleware(
#CORSMiddleware,
#allow_origins='*',
#allow_credentials=False,
#allow_methods=["GET", "PUT","DELETE", "POST", "OPTIONS"],
#allow_headers=["x-apigateway-header", "Content-Type", "X-Amz-Date"],
#)


router = APIRouter()


@router.post("/")
async def get_test():
  print("Received event: " )
  #data = {} #json.loads(event['body'])
  response = {
    'statusCode': 200,
    'body': "sub url call successfull.",
    'headers': {
      'Content-Type': 'application/json'
      }
    }
  return response



@router.post("/xyz")
async def get_root():
  print("Received event: " )
  #data = {} #json.loads(event['body'])
  

  item = {
    'id': 2,
    'name': "halil",
    'title': 'Introduction to DynamoDB',
    'content': 'This is a blog post about how to use DynamoDB.',
    'tags': ['AWS', 'DynamoDB', 'Database']
    }
  #dao.insert_item(item)

  response = {
    'statusCode': 200,
    'body': "dynamo db item inserted successfully multiple gateway creation!.",
    'headers': {
      'Content-Type': 'application/json'
      }
    }
  return response




def gen_routes(app: FastAPI) :
  for route in app.routes:
    if isinstance(route, Mount):
      yield from (
          (f"{route.path}{path}", name) for path, name in gen_routes(route)
          )
    else:
      yield (
          route.path,
          "{}.{}".format(route.endpoint.__module__, route.endpoint.__qualname__),
          )


def list_routes(app):
  routes = sorted(set(gen_routes(app)))
  print(routes)
	



# Create a Mangum handler
#handler = Mangum(app=app, lifespan="off", api_gateway_base_path='/stage')


app.include_router(router, prefix='/lambda_function_002', tags=['hello'])
handler = Mangum(app, lifespan="off", api_gateway_base_path='/')

#def handler(event, context):
#  print(f"event:{event}\n")
#  print(f"context:{context}\n")
#  print("now Mangum will be used...")
#  # ...and let Mangum do the rest, as the above commented-out original code.
#  m = Mangum(app)
#  res = m(event, context)
#  print(f"res:{res}\n")
#  return res




if __name__ == '__main__':
  list_routes(app)
  uvicorn.run(app)
  #print(handler({'body': '{}'}, None))
