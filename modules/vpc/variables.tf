# What INPUTs are Needed.
# Input variables for the VPC module.
# These allow the same module to be reused across dev, staging, and prod
# by just passing different values for each environment.

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name used for tagging"
  type        = string
}