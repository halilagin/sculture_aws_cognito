
cat <<EOF > .env
VITE_COGNITO_USER_POOL_ID=`cat ../infra/appstack.json | jq -r '.aws_cognito_user_pool_id'`
VITE_COGNITO_CLIENT_ID=`cat ../infra/appstack.json | jq -r '.aws_cognito_user_pool_client_id'`
EOF

npm run dev
