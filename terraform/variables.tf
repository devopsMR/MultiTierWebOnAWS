# variables.tf

variable "region" {
  type        = string
  description = "The AWS region where the resources will be created"
}

variable "environment" {
  description = "The environment to deploy (e.g., development, staging, production)."
  type        = string
}

variable "project_name" {
  description = "The base name of the project or application"
  type        = string
}

variable "owner" {
  description = "The owner or responsible person for the resource"
  type        = string
}

variable "team" {
  description = "The team responsible for the resource"
  type        = string
}

variable "cost_center" {
  description = "The cost center used for FinOps tracking"
  type        = string
}


variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to create"
  default     = "t2.micro"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to use"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}


variable "instance_count" {
  type        = number
  description = "Number of instances to launch"
  default     = 2
}

variable "instance_tags" {
  type        = map(string)
  description = "Tags to apply to each instance"
}