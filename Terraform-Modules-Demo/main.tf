module "ec2_instance" {
  source        = "./modules/ec2"
  ami_value     = "ami-05e00961530ae1b55"
  instance-type = "t2.micro"
  secret        = "aws-secret"
}