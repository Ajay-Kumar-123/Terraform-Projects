data "aws_vpc" "vpc" {
  default = true
}

resource "aws_security_group" "dev-sg" {
  name = "Dev-SG"
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

  egress {
    description = "All outbound ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-SG"
  }
}

resource "aws_security_group" "staging-sg" {
  name = "Staging-SG"
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

  egress {
    description = "All outbound ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Staging-SG"
  }
}

locals {
  instances = {
    "Dev" = {
        ami = "ami-05e00961530ae1b55"
        instance_type = "t2.micro"
        security_groups = [aws_security_group.dev-sg.id]
    },
    "Staging" = {
        ami = "ami-05e00961530ae1b55"
        instance_type = "t2.small"
        security_groups = [aws_security_group.staging-sg.id]
    }
  }
}

resource "aws_instance" "ec2" {
  for_each = local.instances
  ami = each.value.ami
  instance_type = each.value.instance_type
  vpc_security_group_ids = each.value.security_groups
  key_name = "aws-secret"

  tags = {
    Name = each.key
  }
}