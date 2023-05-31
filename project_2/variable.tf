# Declaring variable of instance_type
variable "instance_type" {
  type        = list(string)
  description = "acceptable instance types"
}
# declaring cidr blocks
variable "cidr" {
  description = "map of cidr"
  type        = map(string)
}
variable "allowed_cidr" {
  type        = list(string)
  description = "list of permitted cidrs"
}
variable "allowed_ports" {
  type        = list(string)
  description = "list all all allowed ports to serve for the security group resource."
}
variable "email" {
  type        = string
  description = "value for company email"
}
variable "maintainer" {
  type        = string
  description = "value for maintainer' name"
}