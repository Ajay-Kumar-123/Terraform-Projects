resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet1-cidr
  availability_zone       = var.subnet1-az
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet2-cidr
  availability_zone       = var.subnet2-az
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt1" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet-1.id
}

resource "aws_route_table_association" "rt2" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet-2.id
}

