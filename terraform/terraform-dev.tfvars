# terraform-dev.tfvars

region = "eu-central-1"
environment = "development"
project_name = "my-terrraform-project"

availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
private_subnets = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

instance_type = "t3.medium"
instance_count = 3

instance_tags = {
  Environment = "develpoyment"
  Owner       = "devops-team"
}