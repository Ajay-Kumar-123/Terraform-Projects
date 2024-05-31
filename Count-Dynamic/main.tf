data "aws_vpc" "aws_vpc" {
  default = true
}

resource "aws_security_group" "sg" {
  name   = "Test-SG"
  vpc_id = data.aws_vpc.aws_vpc.id

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

#Define the locals block to set the server names
locals {
  server_names = ["backend-A", "backend-B", "backend-C"]
}

resource "aws_instance" "ec2" {
  ami                    = var.ami-value
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.secret
  count                  = length(local.server_names)

  tags = {
    Name = local.server_names[count.index]
  }

}