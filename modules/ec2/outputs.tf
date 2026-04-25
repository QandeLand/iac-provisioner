# The OUTPUT what Terraform will give back
# Outputs expose the instance ID and public IP
# so I can easily find and connect to the server after deployment.


output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main.public_ip
}