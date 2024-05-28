resource "aws_vpc" "test-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Test-VPC"
  }

}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.test-vpc
  cidr_block = var.subnet1_cidr
  availability_zone = var.subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "Test-Subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.test-vpc
  cidr_block = var.subnet2_cidr
  availability_zone = var.subnet2_az
  map_public_ip_on_launch = true

  tags = {
    Name = "Test-Subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test-vpc

  tags = {
    Name = "Test-IGW"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.test-vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw
  }

  tags = {
    Name = "Test-RT"
  }
}

resource "aws_route_table_association" "rt1" {
  route_table_id = aws_route_table.rt
  subnet_id = aws_subnet.subnet-1
}

resource "aws_route_table_association" "rt2" {
  route_table_id = aws_route_table.rt
  subnet_id = aws_subnet.subnet-2
}


resource "aws_security_group" "sg" {
  name = "Test-SG"
  vpc_id = aws_vpc.test-vpc

  ingress {
    description = "SSH-Port"
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
    description = "All outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Test-SG"
  }
}

resource "aws_security_group" "lb-sg" {
  name = "Load-Balancer-SG"
  vpc_id = aws_vpc.test-vpc

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
    description = "LB All Outward Ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Load-Balancer-SG"
  }
}

resource "aws_s3_bucket" "s3" {
  bucket = "testdevopss32024"
}

resource "aws_s3_bucket_public_access_block" "s3-block" {
    bucket = aws_s3_bucket.s3

    block_public_policy = false
    block_public_acls = false
    ignore_public_acls = false
    restrict_public_buckets = false  
}

resource "aws_s3_bucket_ownership_controls" "s3-ownership" {
  bucket = aws_s3_bucket.s3

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3-acl" {
    depends_on = [ aws_s3_bucket_ownership_controls.s3-ownership ]

    bucket = aws_s3_bucket.s3
    acl = "public-read"
  
}


resource "aws_instance" "ec2-1" {
 ami = var.ami
 instance_type = var.instance-type
 vpc_security_group_ids = [aws_security_group.sg]
 subnet_id = aws_subnet.subnet-1
 user_data = base64encode(file("userdata.sh"))
 key_name = var.secret

 root_block_device {
   volume_size = 10
 }

 tags = {
   Name = "Test-EC2-1"
 }
}

resource "aws_instance" "ec2-2" {
  ami = var.ami
  instance_type = var.instance-type
  vpc_security_group_ids = [aws_security_group.sg]
  subnet_id = aws_subnet.subnet-2
  user_data = base64encode(file("userdata1.sh"))
  key_name = var.secret

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "Test-EC2-2"
  }
}

resource "aws_lb" "alb" {
  name = "Test-ALB"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb-sg]
  subnets = [aws_subnet.subnet-1, aws_subnet.subnet-2]

  tags = {
    Name = "Test-ALB"
  }
}

resource "aws_lb_target_group" "alb-tg" {
    name = "Test-ALB-TG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.test-vpc

    health_check {
      path = "/"
      port = "traffic-port"
    }
}

resource "aws_lb_target_group_attachment" "alb-tg-1" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.ec2-1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "alb-tg-2" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.ec2-2.id
  port = 80
}

resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      target_group_arn = aws_lb_target_group.alb-tg.arn
      type = "forward"
    }
}

resource "aws_eip" "eip-1" {
  domain = "vpc"

  tags = {
    Name = "EIP-1"
  }
}

resource "aws_eip" "eip-2" {
  domain = "vpc"

  tags = {
    Name = "EIP-2"
  }
}

resource "aws_eip_association" "eip1-association" {
  instance_id = aws_instance.ec2-1.id
  allocation_id = aws_eip.eip-1.id
}

resource "aws_eip_association" "eip2-association" {
  instance_id = aws_instance.ec2-2.id
  allocation_id = aws_eip.eip-2.id
}