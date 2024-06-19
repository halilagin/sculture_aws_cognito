terraform {
  required_version = ">= 0.13"  # Make sure your Terraform version is compatible

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.49.0"  # Specify the minimum provider version
    }
  }
}


provider "aws" {
  region = "us-east-2"
  #version = ">= 3.49.0"
}

