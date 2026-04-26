# What Is Build
# This module builds the core network layer for each environment.
# It creates a VPC with public and private subnets, an internet gateway,
# and the route tables needed to connect everything together.
# EC2 lives in the public subnet, RDS stays in the private one — 
# that way the database is never directly exposed to the internet.

data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Environment = var.environment
  }
}

# Public subnet — EC2 lives here, needs public IP to be reachable
#tfsec:ignore:aws-ec2-no-public-ip-subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-public-subnet"
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet-a"
    Environment = var.environment
  }
}

# Second private subnet in a different AZ — required by RDS
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 3)
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet-b"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project}-${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# VPC Flow Logs — captures all network traffic for security monitoring
resource "aws_flow_log" "main" {
  vpc_id          = aws_vpc.main.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "flow_log" {
  name              = "/aws/vpc/${var.project}-${var.environment}-flow-logs"
  retention_in_days = 7
}

resource "aws_iam_role" "flow_log" {
  name = "${var.project}-${var.environment}-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
    }]
  })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "flow_log" {
  name = "${var.project}-${var.environment}-flow-log-policy"
  role = aws_iam_role.flow_log.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }]
  })
}