# terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # it is always required to use ther terraform block to determine the appropriate version for your code. 
    }
  }

  # Configure remote state management
  backend "s3" {
    bucket = "tf-deepdive-remote-storage"
    key    = "dev/project_2/terraform.tfstate"
    region = "us-east-1"

    # Configure state file locking
    dynamodb_table = "terraform-state-locking-project_2"
  }

}

# Define a Provider
provider "aws" {
  alias = "region"
}
data "aws_region" "current" {
  provider = aws.region
}
