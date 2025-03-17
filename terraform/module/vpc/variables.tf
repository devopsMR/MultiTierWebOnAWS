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
