# General
variable "env_prefix" {
  type        = string
}

variable "public_key_location" {
  description = "Path to the public SSH key file"
  type        = string
}

# EC2 Instance Configuration
variable "instance_type" {
  default = "t2.micro"
}

variable "entery_ec2_script" {
  description = "Path to the userdata script file for EC2 instances"
  type        = string
}

variable "desired_capacity" {
  default = 2
}

variable "max_size" {
  default = 3
}

variable "min_size" {
  default = 1
}

variable "public_subnet_ids" {
  description = "List of public subnets across multiple AZs for the ASG"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security groups to assign to instances"
  type        = list(string)
}

