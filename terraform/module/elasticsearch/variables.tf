variable "env_prefix" {
  type        = string
}

variable "region" {
  type        = string
  description = "The AWS region where the resources will be created"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
  description = "The type of EC2 instance"
}

variable "public_key_location" {
  description = "Path to the public SSH key file"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security groups to assign to instances"
  type        = list(string)
}

variable "public_subnet_id" {
  description = "public subnet id"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of public subnets across multiple AZs for the ASG"
  type        = list(string)
}

variable "opensearch_sg_id" {
  description = "ID of the security group for opensearch (from the security module)"
  type        = string
}