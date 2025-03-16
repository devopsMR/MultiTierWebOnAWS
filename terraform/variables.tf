# variables.tf
variable "region" {
  type        = string
  description = "The AWS region where the resources will be created"
}

variable "vpc_cidr_block" {
  type        = string
}

variable "env_prefix" {
  description = "environment dev, test or prod"
  type        = string
}

variable "availability_zones" {
  type        = list(string)
}

variable "private_subnets" {
  description = "Must match the number of availability zones."
  type        = list(string)
}

variable "public_subnets" {
  description = "Must match the number of availability zones."
  type        = list(string)
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






