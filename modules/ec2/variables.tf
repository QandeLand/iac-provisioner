# What INPUTs are Needed.
# Input variables for the EC2 module.
# Instance type defaults to t2.micro to stay within AWS free tier limits.
# VPC and subnet IDs are passed in from the VPC module outputs.



variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name used for tagging"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "VPC ID where EC2 will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be deployed"
  type        = string
}