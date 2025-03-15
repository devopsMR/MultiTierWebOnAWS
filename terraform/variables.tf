# variables.tf
variable "region" {
  type        = string
  description = "The AWS region where the resources will be created"
}

variable "env_prefix" {
  description = "The environment to deploy (e.g., development, staging, production)."
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
}

variable "subnet_cidr_block" {
  type        = string
}

variable "avail_zone" {
  type        = string
  description = "List of availability zones to use"
}

variable "my_ip" {
  type        = string
  description = "IP address of the machine running terraform"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to create"
  default     = "t2.micro"
}

variable "public_key_location" {
  type        = string
}

variable "entery_ec2_script" {
  type        = string
}


# variable "private_subnets" {
#   type        = list(string)
#   description = "List of private subnet CIDR blocks"
# }
#
# variable "public_subnets" {
#   type        = list(string)
#   description = "List of public subnet CIDR blocks"
# }
#
#
# variable "instance_count" {
#   type        = number
#   description = "Number of instances to launch"
#   default     = 2
# }
#
# variable "instance_tags" {
#   type        = map(string)
#   description = "Tags to apply to each instance"
# }