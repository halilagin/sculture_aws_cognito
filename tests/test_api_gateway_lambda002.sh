source /usr/local/bin/awsha
access_token=` python boto3_cognito_get_user_accesstoken.py   | sed "s/'/\"/g"|jq .IdToken| tr -d \'\"`
gateway_id=`cat ../infra/appstack.json | jq .aws_api_gateway_rest_api_id | tr -d \'\"`
region=`cat ../infra/appstack.json | jq .region | tr -d \'\"`
set -x
curl -v -X POST  https://$gateway_id.execute-api.$region.amazonaws.com/stage/lambda_function_002 \
  -H "Content-Type: application/json" \
  -H "Authorization: $access_token" \
  -d '{"name":"value1","surname":"value2"}'
