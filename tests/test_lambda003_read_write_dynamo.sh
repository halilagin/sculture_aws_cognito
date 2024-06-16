source /usr/local/bin/awsha
access_token=` python boto3_cognito_get_user_accesstoken.py   | sed "s/'/\"/g"|jq .IdToken| tr -d \'\"`
gateway_id=`cat ../infra/appstack.json | jq .aws_api_gateway_rest_api_id | tr -d \'\"`
region=`cat ../infra/appstack.json | jq .region | tr -d \'\"`

function request {
body_str=$1
curl  -X POST  https://$gateway_id.execute-api.$region.amazonaws.com/stage/lambda_function_003 \
-H "Content-Type: application/json" \
-H "Authorization: $access_token" \
-d "$body_str"
echo
}


for i in {1002..1005}; do

read -r -d '' body_str <<EOF
{
  "action": "insert",
  "items": [{
    "id": $i,
    "name": "name_$i",
    "age": $i
  }]
}
EOF

request "$body_str"

read -r -d '' body_str <<EOF
{
  "action": "get",
  "record_key": {
    "id": $i, 
    "name": "name_$i"
  }
}
EOF

request "$body_str"
done


 
