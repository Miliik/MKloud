resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-${var.vpcname}-vpc-main"
  }

}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags = {
    Name = "${var.public_subnet_tag_name}"
  }
}

# Create a private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.private_subnet_tag_name}"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-${var.vpcname}-internet-gateway"
  }
}

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-${var.vpcname}-public-route-table"
  }
}

# Create a route to the Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create a private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-${var.vpcname}-private-route-table"
  }
}

# Associate the private subnet with the private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Create sg
resource "aws_security_group" "kungfu_sg" {
  name        = "tf-${var.vpcname}-sg"
  description = "Allow SSH & HTTPS traffic from current IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow all ingress"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-${var.vpcname}-sg"
  }
}
