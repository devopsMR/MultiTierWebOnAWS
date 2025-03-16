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