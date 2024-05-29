output "ec2-ip" {
  value = aws_instance.test-ec2.public_ip
}
