resource "aws_s3_bucket" "lambda_fns" {
  bucket = "aws-cognito-lambda-fns"

  tags = {
    Name        = "My Terraform Bucket"
    Environment = "Development"
  }
}


resource "aws_s3_object" "sample01_lambda_fn" {
  bucket = aws_s3_bucket.lambda_fns.bucket
  key    = "sample01_lambda_function.zip"
  source = "../python_src/lambda_functions/sample01_lambda_function.zip"
  depends_on = [aws_s3_bucket.lambda_fns]
}


