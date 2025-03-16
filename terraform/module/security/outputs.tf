output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.ec2_sg.name
}

output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}
