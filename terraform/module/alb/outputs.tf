output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.nginx_alb.arn
}

output "alb_dns_name" {
  description = "DNS Name of the Application Load Balancer"
  value       = aws_lb.nginx_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.nginx_target_group.arn
}