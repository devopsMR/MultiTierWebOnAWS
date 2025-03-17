# RDS Instance Endpoint
output "rds_endpoint" {
  description = "RDS MySQL Instance Endpoint"
  value       = aws_db_instance.rds_mysql_instance.endpoint
}

# RDS Subnet Group Name
output "rds_subnet_group_name" {
  description = "RDS Subnet Group Name"
  value       = aws_db_subnet_group.rds_subnet_group.name
}
