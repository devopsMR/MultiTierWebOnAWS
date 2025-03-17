resource "aws_security_group" "ec2_sg" {
  name   = "${var.env_prefix}-ec2-sg"
  vpc_id = var.vpc_id

  # Ingress - incoming traffic to a resource
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Egress - outgoing traffic from a resource
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      prefix_list_ids = egress.value.prefix_list_ids
    }
  }

  tags = merge(
    {
      Name = "${var.env_prefix}-ec2-sg"
    },
    var.tags
  )
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.env_prefix}-alb-sg"
  description = "Security group for the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = merge(
    {
      Name = "${var.env_prefix}-alb-sg"
    },
    var.tags
  )
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.env_prefix}-rds-sg"
  description = "Security group for RDS MySQL"
  vpc_id      = var.vpc_id

  # Allow MySQL traffic (port 3306) only from allowed EC2 security groups
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = var.allowed_security_groups # List of allowed EC2 security group IDs
  }

  # Outbound traffic (optional, can be restricted further based on needs)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.env_prefix}-rds-sg"
    },
    var.tags
  )
}
