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

# ----------------------------------------------------
# CREATE VPC 
# ----------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.name}-vpc"
  }
}

# ----------------------------------------------------
# CREATE PUBLIC SUBNETS 
# ----------------------------------------------------


resource "aws_subnet" "public_subnet" {
  count      = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.public_subnets_cidr, count.index)
  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
  }
}

# ----------------------------------------------------
# CREATE PRIVATE SUBNETS 
# ----------------------------------------------------

resource "aws_subnet" "private_subnet" {
  count      = length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.private_subnets_cidr, count.index)
  tags = {
    Name = "${var.name}-private-subnet-${count.index + 1}"
  }
}

# ----------------------------------------------------
# CREATE INTERNET GATEWAY 
# ----------------------------------------------------

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-internet-public-gw"
  }
}

# ----------------------------------------------------
# CREATE PUBLIC ROUTE TABLE & ASSOCIATION
# ----------------------------------------------------

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.public_route
    gateway_id = aws_internet_gateway.public_gateway.id
  }
  tags = {
    Name = "${var.name}-public route table"
  }
}

resource "aws_route_table_association" "association_public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route.id
  depends_on     = [aws_route_table.public_route]
}

# ----------------------------------------------------
# CREATE PRIVATE ROUTE TABLE & ASSOCIATION
# ----------------------------------------------------

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-private route table"
  }
}

resource "aws_route_table_association" "association_private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route.id
  depends_on     = [aws_route_table.private_route]
}