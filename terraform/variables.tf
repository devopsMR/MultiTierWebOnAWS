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

variable "route53_zone_id" {
  description = "The ID of the Route 53 Hosted Zone"
  type        = string
}

variable "route53_record_name" {
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
}


# variable "bucket_name" {
#   description = "Bucket name suffix"
#   type        = string
# }
#
# variable "upload_file" {
#   description = "Path to the file to be uploaded with KMS encryption"
#   type        = string
# }
#
# variable "user_group_name" {
#   description = "The IAM user group to grant access to the KMS key"
#   type        = string
# }








