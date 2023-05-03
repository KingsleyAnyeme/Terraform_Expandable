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
# - Create resource. It is a logical representation of the infrastructure object you wnt to create
# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "terraform-on-aws"
    "Department" = "Development"
  }
}
resource "aws_subnet" "public" {
  vpc_id = "aws_vpc.my_vpc.id"
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true 
}
resource "aws_subnet" "private" {
  vpc_id = "aws_vpc.my_vpc.id"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2b"
}