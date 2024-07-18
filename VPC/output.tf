output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}
output "vpc_public_subnet" {
  description = "VPC Public subnet ID"
  value       = [aws_subnet.public_subnet.*.id]
}
output "vpc_private_subnet" {
  description = "VPC Private subnet ID"
  value       = [aws_subnet.private_subnet.*.id]
}

