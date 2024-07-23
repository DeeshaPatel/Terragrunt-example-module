terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "${var.name}-instance"
  }
}

resource "aws_security_group" "security_group" {
  name        = "${var.name}-asg"
  description = "EC2 Security group"
  tags = {
    Name = "${var.name}-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol       = var.protocol
  from_port         = var.from_port
  to_port           = var.to_port
  cidr_ipv4         = var.ingress_ip
}

resource "aws_vpc_security_group_egress_rule" "egree" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = var.public_route
}

resource "aws_subnet" "subnet" {
    cidr_block = "10.0.0.0/16"
    vpc_id = aws_vpc.vpc.id
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.1.0/24"
}
