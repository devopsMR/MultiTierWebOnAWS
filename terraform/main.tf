resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
}

#data "aws_ami" "docker_ami" {}