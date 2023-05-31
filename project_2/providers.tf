# terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # it is always required to use ther terraform block to determine the appropriate version for your code. 
    }
  }
}

# Define a Provider
provider "aws" {
  alias = "region"
}
data "aws_region" "current" {
  provider = aws.region
}
