data "aws_vpc" "vpc" {
  default = true
}

resource "aws_security_group" "sg" {
  name   = "Test-SG"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    description = "SSH Port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Port"
    from_port   = 80
    to_port     = 80
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
    Name = "Test-SG"
  }
}

resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.secret
  count                  = 3

  tags = {
    Name = "Server-${count.index}"
  }
}