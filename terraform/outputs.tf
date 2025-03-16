output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "ec2_public_ips" {
  value = module.asg.ec2_public_ips
}
