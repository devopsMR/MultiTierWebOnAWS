variable "env_prefix" {
  description = "environment dev, test or prod"
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    prefix_list_ids = list(string)
  }))
  default = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      prefix_list_ids = []
    }
  ]
}

variable "tags" {
  description = "Additional tags to be applied to the security group"
  type        = map(string)
  default     = {}
}

variable "allowed_security_groups" {
  description = "IDs of security groups allowed to connect to RDS (e.g., EC2 instance security groups)"
  type        = list(string)
}
