# What Is Build
# This module builds the core network layer for each environment.
# It creates a VPC with public and private subnets, an internet gateway,
# and the route tables needed to connect everything together.
# EC2 lives in the public subnet, RDS stays in the private one — 
# that way the database is never directly exposed to the internet.


resource "aws_vpc" "main" {
    cidr_block = var.vps_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags = {
        Name = "${var.project}-${var.environment}-vpc"
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
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 2)

  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet"
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