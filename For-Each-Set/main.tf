data "aws_vpc" "vpc" {
  default = true
}

resource "aws_security_group" "sg" {
  name = "SG"
  vpc_id = data.aws_vpc.vpc.id

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

  tags = {
    Name = "SG"
  }
}

 locals {
    instances = toset(["Dev", "Staging", "Production"])
  }

resource "aws_instance" "ec2" {
  ami = var.ami-value
  instance_type = var.instance
  vpc_security_group_ids = [aws_security_group.sg.id]
  for_each = local.instances
  key_name = var.secret

  tags = {
    Name = each.value
  }
}