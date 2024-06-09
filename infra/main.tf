provider "aws" {
  region = "us-east-2"
}

resource "aws_cognito_user_pool" "sculture" {
  name = "sculture-user-pool"

  alias_attributes = ["email"]

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  schema {
    attribute_data_type      = "String"
    name                     = "email"
    required                 = true
    mutable                  = false
    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }
}

resource "aws_cognito_user_pool_client" "sculture_pool_client" {
  name         = "sculture-client"
  user_pool_id = aws_cognito_user_pool.sculture.id

  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  callback_urls                        = ["https://sculture.peralabs.co.uk/callback"]
  logout_urls                          = ["https://sculture.peralabs.co.uk/logout"]
}


output "user_pool_id" {
  value = aws_cognito_user_pool.sculture.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.sculture_pool_client.id
}
