
#vim folds: zo, zc, ZM, zR
#vim: setlocal foldmethod=syntax

  resource "aws_dynamodb_table" "dyn_simple_table" {
    name           = var.dynamodb_table_name
    billing_mode   = "PROVISIONED"
    read_capacity  = 10
    write_capacity = 10
    hash_key       = "id"
    range_key       = "name"

    attribute {
      name = "id"
      type = "N"
    }

    attribute {
      name = "name"
      type = "S"
    }



    ttl {
      attribute_name = "TimeToExist"
      enabled        = true
    }


    tags = {
      Name        = "dyn_simple_table"
      Environment = "stage"
    }
  }


resource "aws_dynamodb_table_item" "example_item" {
  table_name = aws_dynamodb_table.dyn_simple_table.name
  hash_key   = aws_dynamodb_table.dyn_simple_table.hash_key
  range_key  = aws_dynamodb_table.dyn_simple_table.range_key

  item = <<ITEM
{
  "id": {"N": "101"},
  "name": {"S": "halil"},
  "tags": {"SS": ["AWS", "DynamoDB", "Database"]}
}
ITEM
}
