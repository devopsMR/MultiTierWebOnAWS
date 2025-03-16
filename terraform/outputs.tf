output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway attached to the VPC."
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT Gateways for the private subnets."
  value       = module.vpc.nat_gateway_ids
}

output "nat_gateway_elastic_ips" {
  description = "The Elastic IPs assigned to the NAT Gateways."
  value       = module.vpc.nat_gateway_elastic_ips
}

output "public_route_table_id" {
  description = "The route table ID for the public subnets."
  value       = module.vpc.public_route_table_id
}

output "private_route_table_ids" {
  description = "The route table IDs for the private subnets."
  value       = module.vpc.private_route_table_ids
}

#
# output "aws_ami_id" {
#   value = data.aws_ami.latest-amazon-linux-image.id
# }
#
# output "ec2_instance_public_ip" {
#   value = aws_instance.myapp-instance.public_ip
# }