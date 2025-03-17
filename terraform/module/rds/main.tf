# RDS MySQL Parameter Group
resource "aws_db_parameter_group" "rds_mysql_parameter_group" {
  name        = "${var.env_prefix}-mysql-parameter-group"
  family      = "mysql8.0"
  description = "Custom parameter group for RDS MySQL"

  parameter {
    name  = "max_connections"
    value = "200"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }


  tags = merge(
    {
      Name = "${var.env_prefix}-mysql-parameter-group"
    },
    var.tags
    )
}

# RDS Subnet Group - Assign RDS to private subnets
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.env_prefix}-mysql-subnet-group"
  subnet_ids = var.private_subnets

  tags = merge(
    {
      Name = "${var.env_prefix}-mysql-subnet-group"
    },
    var.tags
  )
}

# RDS MySQL Instance
resource "aws_db_instance" "rds_mysql_instance" {
  identifier              = "${var.env_prefix}-rds-mysql"
  engine                  = "mysql"
  engine_version          = var.db_engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  storage_type            = var.storage_type
  multi_az                = var.multi_az
  publicly_accessible     = false # Ensures it's in the private subnets
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.rds_security_group_id] # Security group passed in from the security module
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_id
  parameter_group_name    = aws_db_parameter_group.rds_mysql_parameter_group.id
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = var.skip_final_snapshot


  tags = merge(
    {
      Name = "${var.env_prefix}-rds-mysql"
    },
    var.tags
  )
}