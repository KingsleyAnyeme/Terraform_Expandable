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
  region = "us-west-2"
}
#creating a Linux 2 EC2 resource
resource "aws_instance" "my-ec2" {
  ami = "ami-0ac64ad8517166fb1"
  instance_type = "t3.micro"
  key_name = "terraform_test"
  associate_public_ip_address = true

  tags = {
    "Name" = "terraform-on-aws"
    "Department" = "Development"
  }
}