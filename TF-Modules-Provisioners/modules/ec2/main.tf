resource "aws_security_group" "sg" {
  name = "SG"
  vpc_id = aws_vpc.vpc-id

  ingress {
    description = "SSH Port"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Port"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb-sg" {
  name = "LB-SG"
  vpc_id = aws_vpc.vpc-id

  ingress {
    description = "SSH Port"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Port"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2-a" {
  ami = var.ami-value
  instance_type = var.instance
  subnet_id = aws_subnet.subnet-1.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.secret

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "EC2-A"
  }
}

resource "aws_instance" "ec2-b" {
  ami = var.ami-value
  instance_type = var.instance
  subnet_id = aws_subnet.subnet-2.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.secret

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "EC2-B"
  }
}

resource "aws_eip" "eip-a" {
  domain = "vpc"

  tags = {
    Name = "EC2-A EIP"
  }
}

resource "aws_eip" "eip-b" {
  domain = "vpc"

  tags = {
    Name = "EC2-B EIP"
  }
}

resource "aws_eip_association" "ec2-a-assoc" {
  instance_id = aws_instance.ec2-a.id
  allocation_id = aws_eip.eip-a.id
}

resource "aws_eip_association" "ec2-b-assoc" {
  instance_id = aws_instance.ec2-b.id
  allocation_id = aws_eip.eip-b.id
}