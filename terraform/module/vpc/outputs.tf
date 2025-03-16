output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "public_subnet_ids" {
  description = "public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat_gateway[*].id
}

output "nat_gateway_elastic_ips" {
  value = aws_eip.nat_eip[*].public_ip
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "private_route_table_ids" {
  value = aws_route_table.private_route_table[*].id
}

output "public_route_table_association_ids" {
  value = aws_route_table_association.public_subnet_association[*].id
}

output "private_route_table_association_ids" {
  value = aws_route_table_association.private_route_table_association[*].id
}