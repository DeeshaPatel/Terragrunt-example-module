variable "aws_region" {}
variable "environment" {}
variable "name" {}
variable "ami" {}
variable "instance_type" {}
variable "ingress_ip" {}
variable "public_route" {}
variable "protocol" {
  type    = string
  default = "tcp"
}
variable "to_port" {
  type    = number
  default = 22
}
variable "from_port" {
  type    = number
  default = 22
}