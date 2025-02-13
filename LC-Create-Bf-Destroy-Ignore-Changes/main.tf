resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/23"

  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "sub-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
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

  tags = {
    Name = "Route-Table"
  }
}

resource "aws_route_table_association" "rt-assc" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.sub-1.id
}

resource "aws_security_group" "sg" {
  name   = "SG"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH Port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom Port"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG"
  }
}

resource "aws_instance" "ec2" {
  ami                    = var.ami-value
  instance_type          = var.instance
  subnet_id              = aws_subnet.sub-1.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.secret

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      tags
    ]
  }

  tags = {
    Name = "Front-End"
  }
}
