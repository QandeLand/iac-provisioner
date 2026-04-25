# Staging environment configuration.
# Mirrors prod as closely as possible so I can catch issues
# before they reach real users.

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//vpc"
}

inputs = {
  environment = "staging"
  vpc_cidr    = "10.1.0.0/16"
  
  # EC2 — same as dev, kept small for cost control
  instance_type = "t2.micro"
  
  # RDS — same as dev
  instance_class = "db.t3.micro"
  db_name        = "stagingdb"
  db_username    = "adminuser"
  db_password    = "changeme123"
}