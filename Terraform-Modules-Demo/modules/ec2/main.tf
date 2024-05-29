data "aws_vpc" "vpc" {
  default = true
}

resource "aws_security_group" "sg" {
  name   = "New-SG"
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
    description = "All Outbound Ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "New-SG"
  }
}

resource "aws_instance" "ec2" {
  ami                    = var.ami_value
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.secret

  tags = {
    Name = "New-EC2"
  }
}


