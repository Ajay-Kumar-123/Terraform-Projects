module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/23"
  subnet1-cidr = "10.0.0.0/24"
  subnet2-cidr = "10.0.1.0/24"
  subnet1-az = "ap-south-1a"
  subnet2-az = "ap-south-1b"
}

module "ec2" {
  source = "./modules/ec2"
  ami-value = "ami-05e00961530ae1b55"
  instance = "t2.micro"
  secret = "aws-secret"
}

module "lb" {
  source = "./modules/lb"
}

