# Root configuration for the dev environment.
# Calls all three modules in the correct order —
# VPC first, then EC2 and RDS inside it.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  project     = var.project
}

module "ec2" {
  source = "../../modules/ec2"

  environment   = var.environment
  project       = var.project
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
}

module "rds" {
  source = "../../modules/rds"

  environment       = var.environment
  project           = var.project
  instance_class    = var.instance_class
  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}