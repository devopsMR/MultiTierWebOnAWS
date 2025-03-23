module "vpc" {
  source = "./module/vpc"

  vpc_cidr_block    = var.vpc_cidr_block
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets

  env_prefix        = var.env_prefix
}

module "security" {
  source   = "./module/security"
  env_prefix = var.env_prefix
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  my_ip = var.my_ip
  # will use default ingress and egress rules for EC2
  # as defined in the module’s variables.tf
  allowed_security_groups = [
    module.security.ec2_sg_id
  ]
  tags = {
    Environment = var.env_prefix
  }
}

module "asg" {
  source = "./module/asg"

  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_security_group_ids = [module.security.ec2_sg_id]
  instance_type       = "t2.micro"
  public_key_location = var.public_key_location
  entery_ec2_script   = var.entery_ec2_script
  env_prefix          = var.env_prefix
}

module "alb" {
  source = "./module/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnet_ids
  security_group_id = module.security.alb_sg_id # Security group created by security module
  target_group_name = "nginx-target-group"
  health_check_path = "/"
  route53_zone_id   = var.route53_zone_id # aws route53 list-hosted-zones
  route53_record_name = var.route53_record_name
  desired_capacity = module.asg.desired_capacity

}

#replaces aws_lb_target_group_attachment when you're working with an **Auto Scaling Group (ASG)

resource "aws_autoscaling_attachment" "asg_to_alb" {
  autoscaling_group_name = module.asg.asg_name
  lb_target_group_arn   = module.alb.target_group_arn
  #depends_on = [aws_autoscaling_group.web_asg]
}

module "rds" {
  source              = "./module/rds"
  env_prefix          = var.env_prefix
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnet_ids
  rds_security_group_id = module.security.rds_sg_id
  db_username         = "admin"
  db_password         = "supersecret-password"
  skip_final_snapshot = var.skip_final_snapshot
  tags = {
    Environment = var.env_prefix
  }
}

module "elastic-search" {
  source              = "./module/elasticsearch"
  env_prefix          = var.env_prefix
  public_key_location = var.public_key_location
  public_subnet_id = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.security.ec2_sg_id]
  region = var.region
  opensearch_sg_id    = module.security.opensearch_sg_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

# resource "aws_kinesis_stream" "data_stream" {
#   name             = "${var.env_prefix}-data-stream" # Name of the stream
#   shard_count      = 1                               # Start with one shard for testing
#   retention_period = 24                              # Retain data for 24 hours
#
#   tags = {
#     Name        = "${var.env_prefix}-data-stream"
#     Environment = var.env_prefix
#   }
# }
#
# # KMS
# # Create an S3 bucket
# resource "aws_s3_bucket" "example_bucket" {
#   bucket = "${var.env_prefix}-${var.bucket_name}"
#
#   tags = {
#     Name        = "${var.env_prefix}-${var.bucket_name}"
#     Environment = var.env_prefix
#   }
# }
#
# # fetch root account ARN dynamically from the current caller identity
# data "aws_caller_identity" "current" {}
#
# # Create a KMS key
# resource "aws_kms_key" "example_kms_key" {
#   description             = "KMS key for ${var.env_prefix}"
#   key_usage               = "ENCRYPT_DECRYPT"
#   customer_master_key_spec = "SYMMETRIC_DEFAULT"
#   enable_key_rotation     = true
#
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid       = "AllowKMSKeyManagement"
#         Effect    = "Allow"
#         Principal = {
#           AWS = [
#             "arn:aws:iam::${data.aws_caller_identity.current.account_id}:group/${var.user_group_name}"
#           ]
#         }
#         Action    = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:GenerateDataKey",
#           "kms:DescribeKey"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }
#
# # Upload a file to the bucket with KMS encryption
# resource "aws_s3_object" "file_with_kms" {
#   bucket                      = aws_s3_bucket.example_bucket.id
#   key                         = "example_file_with_kms.txt"
#   source                      = var.upload_file
#   server_side_encryption      = "aws:kms"
#   kms_key_id                  = aws_kms_key.example_kms_key.arn
#   acl                         = "private"
# }
# # upload file via cli with kms
# # aws s3 cp tags.xlsx s3://test-eks-mrosen --sse aws:kms --sse-kms-key-id 40fd905e-a7fb-4c43-9277-f22b754b092c
#
#

# #data "aws_ami" "docker_ami" {}