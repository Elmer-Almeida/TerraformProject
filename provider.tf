# author: Elmer Almeida
# date: dec 17 2021
# contains the AWS provider setup

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

# Configure the provider
provider "aws" {
  region     = "us-east-1"
  access_key = "<access_key>"
  secret_key = "<secret_key>"
  token      = "<token>"
}
