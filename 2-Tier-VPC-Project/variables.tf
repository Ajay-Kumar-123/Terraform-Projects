variable "vpc_cidr" {
  description = "Test VPC CIDR Block"
  default = "10.0.0.0/23"
}

variable "subnet1_cidr" {
  description = "Test Subnet-1 CIDR Block"
  default = "10.0.0.0/24"
}

variable "subnet1_az" {
  description = "Test Subnet-1 Availability Zone"
  default = "ap-south-1a"
}

variable "subnet2_cidr" {
  description = "Test Subnet-2 CIDR Block"
  default = "10.0.1.0/24"
}

variable "subnet2_az" {
  description = "Test Subnet-2 Availability Zone"
  default = "ap-south-1b"
}

variable "ami" {
  description = "AMI for the instances"
  default = "ami-05e00961530ae1b55"
}

variable "instance-type" {
  description = "Instance type"
  default = "t2.micro"
}

variable "secret" {
  description = "Pem Key for the instances"
  default = "aws-secret"
}