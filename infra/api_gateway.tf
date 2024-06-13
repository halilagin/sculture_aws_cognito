
resource "aws_api_gateway_rest_api" "cognito_api" {
  name = "CognitoAPI"

	endpoint_configuration {
    types = ["REGIONAL"]
  }	
provisioner "local-exec" {
    command = <<EOT
    jq '.aws_api_gateway_rest_api_id = "${aws_api_gateway_rest_api.cognito_api.id}"' ${var.appstack_name} |sponge ${var.appstack_name}
    EOT
 } 
}




resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.cognito_api.id
  parent_id   = aws_api_gateway_rest_api.cognito_api.root_resource_id
  path_part   = "example"
}


resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "cognito_authorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.cognito_api.id
  provider_arns = [aws_cognito_user_pool.sculture.arn]
}




resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.cognito_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization =   "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.cognito_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example_lambda["lambda_function_000"].invoke_arn

}


resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.cognito_api.id
  #stage_name  = "stage"
}



resource "aws_cloudwatch_log_group" "example" {
    name = "/aws/apigateway/${aws_api_gateway_rest_api.cognito_api.name}"
}



resource "aws_api_gateway_stage" "example" {
  stage_name    = "stage"
  rest_api_id   = aws_api_gateway_rest_api.cognito_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id


  access_log_settings {
    format = jsonencode({
      "requestId" = "$context.requestId",
      "ip"        = "$context.identity.sourceIp",
      "caller"    = "$context.identity.caller",
      "user"      = "$context.identity.user",
      "requestTime" = "$context.requestTime",
      "httpMethod" = "$context.httpMethod",
      "resourcePath" = "$context.resourcePath",
      "status"    = "$context.status",
      "protocol"  = "$context.protocol",
      "responseLength" = "$context.responseLength"
    })
    destination_arn = aws_cloudwatch_log_group.example.arn
  }
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
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}




# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda["lambda_function_000"].function_name
  principal     = "apigateway.amazonaws.com"

  ## More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  #source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.cognito_api.id}/*/${aws_api_gateway_method.api_method.http_method}/${aws_api_gateway_resource.resource.path}"
  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.cognito_api.id}/*/*/*"
}
