# General Configuration
variable "env_prefix" {
  description = "Environment prefix for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the resources will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets for RDS deployment"
  type        = list(string)
}

# Security Group
variable "rds_security_group_id" {
  description = "ID of the security group for RDS (from the security module)"
  type        = string
}

# RDS MySQL Configuration
variable "db_engine_version" {
  description = "Version of MySQL engine to use"
  type        = string
  default     = "8.0.32"
}

variable "instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial allocated storage (in GB)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage (in GB)"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type (gp2 or io1)"
  type        = string
  default     = "gp2"
}

variable "multi_az" {
  description = "Enable Multi-AZ for high availability"
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS Key ARN for encryption at rest"
  type        = string
  default     = null
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
}

variable "parameter_group_parameters" {
  description = "MySQL custom parameter group settings"
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot before destroying RDS instance"
  type        = bool
  default     = false
}