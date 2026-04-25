# Production environment configuration.
# Slightly larger instances to handle real traffic.
# Never destroy this without double checking first.

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//vpc"
}

inputs = {
  environment = "prod"
  vpc_cidr    = "10.2.0.0/16"
  
  # EC2 — slightly larger for real traffic
  instance_type = "t3.small"
  
  # RDS — same class but treat with more care
  instance_class = "db.t3.micro"
  db_name        = "proddb"
  db_username    = "adminuser"
  db_password    = "changeme123"
}