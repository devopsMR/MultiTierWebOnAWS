variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets for ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = "nginx-target-group"
}

variable "health_check_path" {
  description = "Health check path for Target Group"
  type        = string
  default     = "/"
}

variable "desired_capacity" {
  description = "Desired capacity of instances in the ASG"
  type        = number
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID for the domain"
  type        = string
  default     = null
}

variable "route53_record_name" {
  description = "Domain name for Route 53 record"
  type        = string
  default     = null
}