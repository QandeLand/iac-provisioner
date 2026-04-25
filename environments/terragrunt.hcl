# Root Terragrunt configuration — shared across all environments.
# Defines the remote state backend and common inputs so I don't
# repeat this configuration in every environment folder.

locals {
  aws_region  = "eu-north-1"
  project     = "iac-provisioner"
}

# Remote state — stores Terraform state in S3 with DynamoDB locking.
# This means multiple runs can't conflict with each other.
remote_state {
  backend = "s3"
  config = {
    bucket         = "iac-provisioner-tfstate-${get_aws_account_id()}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "iac-provisioner-tfstate-lock"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Common inputs passed to all environments
inputs = {
  aws_region = local.aws_region
  project    = local.project
}