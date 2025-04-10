# Create a custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create public (DMZ) subnet
resource "aws_subnet" "dmz_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.dmz_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags = {
    Name = "${var.vpc_name}-dmz"
  }
}

# Create private (back) subnet
resource "aws_subnet" "back_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.back_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.vpc_name}-back"
  }
}

# Create an Internet Gateway for the DMZ subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Create a route table for the DMZ subnet
resource "aws_route_table" "dmz_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-dmz-route-table"
  }
}

# Associate the DMZ route table with the DMZ subnet
resource "aws_route_table_association" "dmz_route_table_association" {
  subnet_id      = aws_subnet.dmz_subnet.id
  route_table_id = aws_route_table.dmz_route_table.id
}

# Create a route table for the back subnet (no internet access)
resource "aws_route_table" "back_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "${var.vpc_name}-back-route-table"
  }
}

# Associate the back route table with the back subnet
resource "aws_route_table_association" "back_route_table_association" {
  subnet_id      = aws_subnet.back_subnet.id
  route_table_id = aws_route_table.back_route_table.id
}

# Associate security groups with subnets
resource "aws_network_acl" "dmz_acl" {
  vpc_id = aws_vpc.custom_vpc.id
  subnet_ids = [aws_subnet.dmz_subnet.id]
  tags = {
    Name = "${var.vpc_name}-dmz-acl"
  }
}