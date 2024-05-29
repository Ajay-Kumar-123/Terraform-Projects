output "ec2-a-ip" {
  value = aws_instance.ec2-a.public_ip
}

output "ec2-b-ip" {
  value = aws_instance.ec2-b.public_ip
}

output "lb_sg" {
  value = aws_security_group.lb-sg.id
}

output "ec2-a" {
  value = aws_instance.ec2-a.id
}

output "ec2-b" {
  value = aws_instance.ec2-b.id
}