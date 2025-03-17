output "autoscaling_group_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.web_server.name
}

output "ec2_public_ips" {
  value = data.aws_instances.web_asg_instances.public_ips
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.name
}

output "asg_id" {
  value = aws_autoscaling_group.web_asg.id
}

output "desired_capacity" {
  value = aws_autoscaling_group.web_asg.desired_capacity
}

