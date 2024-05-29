resource "aws_lb" "alb" {
  name = "ALB"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb_sg.id]
  subnets = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]

  tags = {
    Name = "ALB"
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name = "ALB-TG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "tg-att-1" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.ec2-a.id
}

resource "aws_lb_target_group_attachment" "tg-att-2" {
  target_group_arn = aws_lb_target_group.alb-tg.id
  target_id = aws_instance.ec2-b.id
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

