resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



#variable "lambda_fn_names" {
  #type    = list(string)
  #default = tolist([ for i in range(2): format("lambda_function_%03d", i) ])
#}

resource "aws_lambda_function" "example_lambda" {
  for_each = {  for i in local.lambda_functions_range: format("lambda_function_%03d", i) => i}
  function_name = each.key
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  s3_bucket         = aws_s3_bucket.lambda_fns.bucket
  s3_key            = "${each.key}.zip"

  role = aws_iam_role.lambda_execution_role.arn

	depends_on = [ aws_s3_object.sample01_lambda_fn ]
}
