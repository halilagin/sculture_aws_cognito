resource "aws_iam_policy" "access_dynamodb_rw" {
  name   = "DynamoDBAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        Resource = "arn:aws:dynamodb:${var.region}:${var.accountId}:table/${var.dynamodb_table_name}"
      }
    ]
  })
}



