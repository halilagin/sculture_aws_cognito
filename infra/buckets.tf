resource "aws_s3_bucket" "lambda_fns" {
  bucket = "aws-cognito-lambda-fns"

  tags = {
    Name        = "My Terraform Bucket"
    Environment = "Development"
  }
}


resource "aws_s3_object" "sample01_lambda_fn" {
  for_each = {  for i in local.lambda_functions_range: format("lambda_function_%03d", i) => i}
  bucket = aws_s3_bucket.lambda_fns.bucket
  key    = "${each.key}.zip"
  source = "../python_src/lambda_functions/${each.key}.zip"
  depends_on = [aws_s3_bucket.lambda_fns]
}


