# Dev environment configuration.
# Small and cheap — t2.micro stays within AWS free tier limits.
# This is where I test changes before promoting to staging or prod.

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//vpc"
}

inputs = {
  environment = "dev"
  vpc_cidr    = "10.0.0.0/16"
  
  # EC2 — free tier instance
  instance_type = "t2.micro"
  
  # RDS — smallest available instance
  instance_class = "db.t3.micro"
  db_name        = "devdb"
  db_username    = "adminuser"
  db_password    = "changeme123"
}