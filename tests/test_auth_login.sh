client_secret="1fl8n9llpclmm2titdb74j16tm2semgnr76v41jops04uagrbrtj"
client_id="47voi8t2b3gvbeothl3al4ghsp"
authirization_basic=`echo -n "$client_id:$client_secret" | base64`
username="halilagin" 
password="YourTempPassword2024!!" 
scope="email openid"
url="https://cognito-idp.us-east-2.amazonaws.com/us-east-2_YDOLK0xD4/oauth2/token"

curl -X POST \
-H "Authorization: Basic $authirization_basic" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "grant_type=client_credentials" \
-d "username=$username" \
-d "password=$password" \
-d "scope=$scope" \
$url


