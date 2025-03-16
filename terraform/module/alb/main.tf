# Target Group for Auto Scaling Instances
resource "aws_lb_target_group" "nginx_target_group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

# Application Load Balancer (ALB)
resource "aws_lb" "nginx_alb" {
  name               = "${var.target_group_name}-alb"
  internal           = false
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets
  load_balancer_type = "application"
  enable_deletion_protection = false

  tags = {
    Name = "${var.target_group_name}-alb"
  }
}

# ALB Listener to Forward Traffic to Target Group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

# (Optional) Route 53 Record to Point to ALB
resource "aws_route53_record" "alias" {
  count = var.route53_zone_id != null && var.route53_record_name != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.route53_record_name
  type    = "A"

  alias {
    name                   = aws_lb.nginx_alb.dns_name
    zone_id                = aws_lb.nginx_alb.zone_id
    evaluate_target_health = true
  }
}