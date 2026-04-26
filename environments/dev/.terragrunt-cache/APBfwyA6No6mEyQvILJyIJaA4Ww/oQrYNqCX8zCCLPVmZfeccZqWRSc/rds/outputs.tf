# The OUTPUT what Terraform will give back
# Outputs expose the database endpoint and name
# so I can connect to it and reference it in other parts of the infrastructure.


output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.main.db_name
}
