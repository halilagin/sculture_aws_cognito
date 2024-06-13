source /usr/local/bin/awsha
if [ ! -f appstack.json ]; then
echo "{}" > appstack.json
fi
terraform apply plan.out

