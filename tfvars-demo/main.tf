data "aws_vpc" "default-vpc" {
  default = true
}

resource "aws_security_group" "sg" {
  name = "Test-SG"
  vpc_id = data.aws_vpc.default-vpc.id

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
    description = "All Outward Ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Test-SG"
  }
}

resource "aws_instance" "test-ec2" {
  ami = var.ami
  instance_type = var.instance-type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = var.secret-key
  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "Test-EC2"
  }
}

resource "aws_eip" "test-ec2-eip" {
  domain = "vpc"

  tags = {
    Name = "Test-EC2-Elastic IP"
  }
}

resource "aws_eip_association" "test-ec2-eip-association" {
  instance_id = aws_instance.test-ec2.id
  allocation_id = aws_eip.test-ec2-eip.id
}