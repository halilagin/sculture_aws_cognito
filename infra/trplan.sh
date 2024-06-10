source /usr/local/bin/awsha
echo "{}" > appstack.json
terraform plan -out=plan.out -var-file=default.tfvars

