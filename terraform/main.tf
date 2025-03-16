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

  # will use default ingress and egress rules as defined in the module’s variables.tf

  tags = {
    Environment = var.env_prefix
  }
}

module "asg" {
  source = "./module/asg"

  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.security.security_group_id]


  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  instance_type       = "t2.micro"
  public_key_location = var.public_key_location
  entery_ec2_script   = var.entery_ec2_script
  env_prefix          = var.env_prefix
}



# data "aws_ami" "latest-amazon-linux-image" {
#   most_recent = true
#   owners = ["amazon"]
#   filter {
#     name = "name"
#     values = ["amzn2-ami-kernel-*-x86_64-gp2"]
#   }
#   filter {
#     name = "virtualization-type"
#     values = ["hvm"]
#   }
# }
#
# resource "aws_key_pair" "ssh-key" {
#   key_name = "server-key"
#   public_key = file(var.public_key_location)
# }
#
# resource "aws_instance" "myapp-instance" {
#   ami = data.aws_ami.latest-amazon-linux-image.id
#   instance_type = var.instance_type
#
#   subnet_id = aws_subnet.myapp-subnet-1.id
#   vpc_security_group_ids = [aws_security_group.myapp-sg.id]
#   # availability_zone = var.avail_zone
#
#   associate_public_ip_address = true
#   key_name = aws_key_pair.ssh-key.key_name
#
#   tags = {
#     Name : "${var.env_prefix}-server"
#   }
#
#   #execute on server creation
#   user_data = file(var.entery_ec2_script)
#   user_data_replace_on_change = true
# }

# #data "aws_ami" "docker_ami" {}