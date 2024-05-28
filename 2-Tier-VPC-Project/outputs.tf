output "albdnsname" {
  value = aws_lb.alb.dns_name
}

output "ec2-1_ip" {
  value = aws_instance.ec2-1.public_ip
}

output "ec2-2_ip" {
  value = aws_instance.ec2-2.public_ip
}