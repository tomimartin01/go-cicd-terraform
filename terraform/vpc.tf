
// This block creates a basic VPC, two public subnets, an internet gateway, and a route table.
// Everything essential so ECS/Fargate can launch tasks accessible from the internet.

// Main VPC for the project. Provides a private network for all resources.
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

// Internet Gateway to allow resources in the VPC to access the internet.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

// First public subnet in a different availability zone. Used for high availability.
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.project_name}-public-a"
  }
}

// Second public subnet in another availability zone. Used for high availability.
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.project_name}-public-b"
  }
}

// Public route table for the VPC. Controls routing for public subnets.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

// Route that sends all outbound traffic (0.0.0.0/0) to the internet gateway.
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

// Associates the first public subnet with the public route table.
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

// Associates the second public subnet with the public route table.
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

// Gets the list of available availability zones in the current AWS region.
data "aws_availability_zones" "available" {}
