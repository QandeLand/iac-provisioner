# The OUTPUT what Terraform will give back
# Outputs expose the VPC, public subnet, and private subnet IDs
# so other modules like EC2 and RDS know where to deploy.


output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}