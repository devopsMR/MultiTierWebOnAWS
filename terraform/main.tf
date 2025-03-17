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
  route53_record_name = "devops-mr.com"
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

# #data "aws_ami" "docker_ami" {}