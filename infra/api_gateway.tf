#vim folds: zo, zc, ZM, zR
#vim: setlocal foldmethod=syntax



resource "aws_iam_role" "api_gateway_execution_role" {
  name = "api_gateway_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Effect = "Allow",
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_policy" {
  role   = aws_iam_role.api_gateway_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = "*",
        Effect = "Allow"
      }
    ]
  })
}



resource "aws_api_gateway_rest_api" "cognito_api" {
  name = "CognitoAPI"
  #role_arn = aws_iam_role.api_gateway_execution_role.arn
	endpoint_configuration {
    types = ["REGIONAL"]
  }	
  provisioner "local-exec" {
    command = <<EOT
    jq '.aws_api_gateway_rest_api_id = "${aws_api_gateway_rest_api.cognito_api.id}"' ${var.appstack_name} |sponge ${var.appstack_name}
    jq '.aws_api_gateway_rest_api_execution_arn = "${aws_api_gateway_rest_api.cognito_api.execution_arn}"' ${var.appstack_name} |sponge ${var.appstack_name}
    EOT
  } 
}

resource "aws_api_gateway_resource" "api_resource" {
  for_each = {  for i in local.lambda_functions_range: format("lambda_function_%03d", i) => i}
  rest_api_id = aws_api_gateway_rest_api.cognito_api.id
  parent_id   = aws_api_gateway_rest_api.cognito_api.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
name          = "cognito_authorizer"
type          = "COGNITO_USER_POOLS"
rest_api_id   = aws_api_gateway_rest_api.cognito_api.id
provider_arns = [aws_cognito_user_pool.sculture.arn]
}

resource "aws_api_gateway_method" "api_method" {
  for_each = {  for i in local.lambda_functions_range: format("lambda_function_%03d", i) => i}
  rest_api_id   = aws_api_gateway_rest_api.cognito_api.id
  resource_id   = aws_api_gateway_resource.api_resource[each.key].id
  http_method   = "ANY"
  authorization =   "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  for_each = {  for i in local.lambda_functions_range: format("lambda_function_%03d", i) => i}
  rest_api_id = aws_api_gateway_rest_api.cognito_api.id
  resource_id = aws_api_gateway_resource.api_resource[each.key].id
  http_method = aws_api_gateway_method.api_method[each.key].http_method
  credentials = aws_iam_role.api_gateway_execution_role.arn

  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example_lambda[each.key].invoke_arn

}

resource "aws_api_gateway_deployment" "api_deployment" {
  #stage_name  = "stage"
  stage_description = "Deployed at ${timestamp()}"
  rest_api_id = aws_api_gateway_rest_api.cognito_api.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_cloudwatch_log_group" "example" {
    name = "/aws/apigateway/${aws_api_gateway_rest_api.cognito_api.name}"
    retention_in_days = 3
}




# Ensure you have the AWS IAM role and policy in place for API Gateway to write logs
resource "aws_iam_role" "api_gw_cloudwatch" {
  name = "api_gw_cloudwatch"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy" "api_gw_cloudwatch" {
  name   = "api_gw_cloudwatch"
  role   = aws_iam_role.api_gw_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
        ],
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}



# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  for_each = {  for i in local.lambda_functions_range: format("lambda_function_%03d", i) => i}
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda[each.key].function_name
  principal     = "apigateway.amazonaws.com"

  ## More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  #source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.cognito_api.id}/*/${aws_api_gateway_method.api_method.http_method}/${aws_api_gateway_resource.resource.path}"
  source_arn = "${aws_api_gateway_rest_api.cognito_api.execution_arn}/*"
 }




resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.cognito_api.id
  stage_name    = "stage"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.example.arn
    format          = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"caller\":\"$context.identity.caller\",\"user\":\"$context.identity.user\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"
  }

	depends_on = [
    aws_iam_role_policy.api_gw_cloudwatch
  ]
}
