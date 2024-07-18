variable "aws_region" {}
variable "environment" {}
variable "name" {}
variable "vpc_cidr" {}
variable "public_route" {}
variable "public_subnets_cidr" {
  type    = list
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnets_cidr" {
  type    = list
  default = ["10.0.3.0/24"]
}

