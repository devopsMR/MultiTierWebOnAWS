output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "ec2_public_ips" {
  value = module.asg.ec2_public_ips
}

output "rds_endpoint" {
  description = "RDS MySQL Instance Endpoint"
  value       = module.rds.rds_endpoint
}
