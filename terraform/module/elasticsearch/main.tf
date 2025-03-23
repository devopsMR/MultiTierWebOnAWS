
# Retrieve details about the current AWS account
data "aws_caller_identity" "current" {}

# Data source to get the latest Ubuntu 20.04 LTS AMI for x86_64 architecture
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]  # Canonical's AWS Account ID for Ubuntu AMIs
}

# Create an OpenSearch domain (dynamically named with environment prefix)
resource "aws_elasticsearch_domain" "opensearch" {
  domain_name           = "${var.env_prefix}-opensearch-domain"
  elasticsearch_version = "OpenSearch_1.0"

  vpc_options {
    subnet_ids         = [var.private_subnet_ids[0]] # Placing in private subnets
    security_group_ids = [var.opensearch_sg_id]
  }

  cluster_config {
    instance_type  = "t3.small.elasticsearch"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = "admin"
      master_user_password = "StrongPassword123!"
    }
  }

  domain_endpoint_options {
    enforce_https = true
  }

  # TEMP: Open access for testing with admin user
  # "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.env_prefix}-ec2-role"
  access_policies = <<-POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.env_prefix}-opensearch-domain/*"
    }
  ]
}
POLICIES

  tags = {
    Name = "${var.env_prefix}-OpenSearch Domain"
  }
}

# Define the AWS Key Pair for SSH access
resource "aws_key_pair" "ssh_key" {
  key_name   = "server-key-for-elastic-ec2"
  public_key = file(var.public_key_location)
}

# EC2 instance to interact with OpenSearch domain
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh_key.key_name

  # Associate EC2 instance with a public IP
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids

  tags = {
    Name = "${var.env_prefix}-opensearch-ec2-instance"
  }

  # Install necessary tools on the EC2 instance
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y awscli curl jq
              EOF
}
# curl -u admin:StrongPassword123! https://vpc-dev-opensearch-domain-blwiz25fvdlbci67qcofvjeou4.eu-central-1.es.amazonaws.com/_cluster/health?pretty
