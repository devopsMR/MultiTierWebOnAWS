# output values: like function return values
output "dev-vpc-id" {
  value =  aws_vpc.myapp-vpc.id
  description = ""
}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2_instance_public_ip" {
  value = aws_instance.myapp-instance.public_ip
}