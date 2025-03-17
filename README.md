# Deploy a Scalable Multi-Tier Web Application on AWS
### Design and implement a scalable, secure, and highly available multi-tier web application infrastructure on AWS using Terraform. 
### including Route 53 Record to Point to ALB

## terraform.tfvars
   ```bash
region = "eu-central-1"
vpc_cidr_block = "10.0.0.0/16"
availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
private_subnets = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
env_prefix = "dev"
instance_type = "t2.micro"
public_key_location = "XXXX"
entery_ec2_script = XXXX/entery-script.sh"
route53_zone_id = "XXXXXXXXXXXXXXXXXXXX"
skip_final_snapshot = true
route53_record_name = "XXXX"
   ```


### terraform commands 
1. **build environment** 
   ```bash
   terraform apply --auto-approve
   ```
2. **destroy environment**
   ```bash
   terraform destroy
   ```
### insert ec2 and test RDS connection
1. **insert ec2**  
   ```bash
   ssh -i aws_ec2_key ec2-user@XXX.XXX.XXX.XXX
   ```
2. **test RDS connection**
   ```bash
   mysql -h dev-rds-mysql.XXXXXXXXXXXX.eu-central-1.rds.amazonaws.com -P 3306 -u admin -p
   
   SHOW DATABASES;
   USE <database_name>;
   SHOW TABLES;
   ```
3

