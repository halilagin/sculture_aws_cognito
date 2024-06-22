source /usr/local/bin/awsha
gateway_name="aws_api_gateway_rest_api_id_lambda_function_002"
access_token=` python boto3_cognito_get_user_accesstoken.py   | sed "s/'/\"/g"|jq .IdToken| tr -d \'\"`
gateway_id=`cat ../infra/appstack.json | jq .$gateway_name | tr -d \'\"`
region=`cat ../infra/appstack.json | jq .region | tr -d \'\"`
method="POST"
#curl -X $method  https://$gateway_id.execute-api.$region.amazonaws.com/stage/lambda_function_002/ \
#-H "Content-Type: application/json" \
#-H "Authorization: $access_token" 
#echo
#curl -X $method  https://$gateway_id.execute-api.$region.amazonaws.com/stage/lambda_function_002/xyz \
#-H "Content-Type: application/json" \
#-H "Authorization: $access_token" 


curl -X $method  https://$gateway_id.execute-api.$region.amazonaws.com/stage/lambda_function_002/xyz \
-H "Content-Type: application/json" \
-H "Authorization: $access_token" 

