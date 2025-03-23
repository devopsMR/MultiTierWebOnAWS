#Security Groups  limit traffic at the instance level.
# NACLs  serve as an additional layer to restrict or allow traffic
# at the subnet level.
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

resource "aws_security_group" "opensearch_sg" {
  name        = "${var.env_prefix}-opensearch-sg"
  description = "Security group for OpenSearch"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-opensearch-sg"
  }
}


# # NACL - Public Subnets
# resource "aws_network_acl" "public_nacl" {
#   vpc_id     = var.vpc_id
#   subnet_ids = var.public_subnet_ids
#
#   tags = {
#     Name = "${var.env_prefix}-public-nacl"
#   }
# }
#
# # Inbound Rules
# resource "aws_network_acl_rule" "allow_http_inbound" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 100
#   protocol       = "6" # TCP
#   rule_action    = "allow"
#   egress         = false
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 80
#   to_port        = 80
# }
#
# resource "aws_network_acl_rule" "allow_https_inbound" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 110
#   protocol       = "6" # TCP
#   rule_action    = "allow"
#   egress         = false
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 443
#   to_port        = 443
# }
#
# resource "aws_network_acl_rule" "allow_ssh_inbound" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 120
#   protocol       = "6" # TCP
#   rule_action    = "allow"
#   egress         = false
#   cidr_block     = "${var.my_ip}/32" # Replace with var.my_ip if needed
#   from_port      = 22
#   to_port        = 22
# }
#
# resource "aws_network_acl_rule" "allow_ephemeral_inbound" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 130
#   protocol       = "6" # TCP
#   rule_action    = "allow"
#   egress         = false
#   cidr_block     = "0.0.0.0/0" # Allow return traffic from anywhere
#   from_port      = 1024
#   to_port        = 65535
# }
# # Outbound Rules
# resource "aws_network_acl_rule" "allow_all_outbound_public" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 100
#   protocol       = "-1" # All protocols
#   rule_action    = "allow"
#   egress         = true
#   cidr_block     = "0.0.0.0/0"
# }
#
# # NACL - Private Subnets
# resource "aws_network_acl" "private_nacl" {
#   vpc_id     = var.vpc_id
#   subnet_ids = var.private_subnet_ids
#
#   tags = {
#     Name = "${var.env_prefix}-private-nacl"
#   }
# }
#
# # Inbound Rules
# resource "aws_network_acl_rule" "allow_http_https_from_alb" {
#   for_each       = toset(var.public_subnets) # Iterate over the public subnet CIDRs
#   network_acl_id = aws_network_acl.private_nacl.id
#   rule_number    = 100 + index(tolist(var.public_subnets), each.key) # Assign unique rule numbers
#   protocol       = "6" # TCP
#   rule_action    = "allow"
#   egress         = false
#   cidr_block     = each.key # Use each public subnet CIDR
#   from_port      = 80
#   to_port        = 443
# }
#
# resource "aws_network_acl_rule" "allow_mysql_inbound" {
#   for_each       = toset(var.private_subnets) # Iterate over private subnets
#   network_acl_id = aws_network_acl.private_nacl.id
#   rule_number    = 200 + index(tolist(var.private_subnets), each.value) # Assign unique rule numbers
#   protocol       = "6" # TCP
#   rule_action    = "allow"
#   egress         = false
#   cidr_block     = each.value # Dynamically use each private subnet CIDR
#   from_port      = 3306
#   to_port        = 3306
# }
#
# # Outbound Rules
# resource "aws_network_acl_rule" "allow_all_outbound_private" {
#   network_acl_id = aws_network_acl.private_nacl.id
#   rule_number    = 100
#   protocol       = "-1" # All protocols
#   rule_action    = "allow"
#   egress         = true
#   cidr_block     = "0.0.0.0/0"
# }
#
# resource "aws_network_acl_rule" "allow_ephemeral_outbound" {
#   network_acl_id = aws_network_acl.private_nacl.id
#   rule_number    = 250
#   protocol       = "6" # TCP
#   rule_action    = "allow"
#   egress         = true
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 1024
#   to_port        = 65535
# }

