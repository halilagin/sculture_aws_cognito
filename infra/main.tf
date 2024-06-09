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

  access_token_validity = 1440  # Access token validity in minutes

  prevent_user_existence_errors = "ENABLED"

  generate_secret = true

  # Identity providers
  supported_identity_providers = ["COGNITO"]


  token_validity_units {
    access_token = "minutes"
  }

  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH","ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit" ]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  callback_urls                        = ["https://sculture.local/callback"]
  logout_urls                          = ["https://sculture.local/logout"]
}


resource "aws_cognito_user_pool_domain" "main" {
  domain       = "example-terraform-hosted-ui"
  user_pool_id = aws_cognito_user_pool.sculture.id
}



resource "aws_cognito_user" "example_user" {
  user_pool_id = aws_cognito_user_pool.sculture.id
  username     = "halilagin"
  
  # Set initial temporary password for the user (use sensitive data management practices)
  #temporary_password = "YourTempPassword2024!!"
  password = "YourTempPassword2024!!"

  # Optional: User attributes
  attributes = {
    name = "Halil Agin"
    email        = "halil.agin@gmail.com"
    email_verified = true
  }

  # Specify whether the email address is marked as verified
  force_alias_creation = false
  message_action       = "SUPPRESS" # Suppresses the sending of any initial emails

  # Optional: User status can be specified (e.g., "CONFIRMED" to bypass email verification)
  #user_status = "CONFIRMED"
}


output "user_pool_id" {
  value = aws_cognito_user_pool.sculture.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.sculture_pool_client.id
}
