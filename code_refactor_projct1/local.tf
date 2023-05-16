locals {
  tags = {
    "Name"       = "terraform-on-aws"
    "Department" = "Development"
    "Maintainer" = var.maintainer
    "Email"      = var.email
  }
}