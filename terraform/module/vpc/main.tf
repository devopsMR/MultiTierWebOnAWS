# A VPC is a virtual (isolated) network in AWS.
# To host resources in the VPC (like EC2 instances), you must create subnets.
# A subnet is a range of IP addresses in the VPC assigned to resources within a specific availability zone.
# An availability zone is an isolated data center in a particular AWS region, designed to be independent of failures in other zones.
# Subnets Are Tied to Availability Zones:
# --- Internet Gateway ---
# Firewall rule configuration makes it either a private or public subnet
# internet gateway (IGW) - connects the VPC to the outside internet
# Public Subnet- A subnet that has a route to the internet through an internet gateway (IGW).
# Typically used for resources like web servers that need to be accessible over the internet.
# Private Subnet - A subnet without direct internet access. Usually, traffic is routed to the internet through a NAT Gateway in a public subnet.
# Used for sensitive resources like databases or application servers.
#
# NAT Gateway  - Used for instances in **private subnets** to access the internet (e.g., for downloads, updates, or API requests),
# while keeping the private subnet instances hidden from public access.
# Requirements:
#   - Needs an **Elastic IP (EIP) to provide a static, publicly routable IP address for outbound internet traffic.
#   - Must be placed in a public subnet , as it relies on the **Internet Gateway** for outbound communication.
# Internet Gateway -A component required for all **public subnets**, enabling instances or resources with public IP
# to send and receive traffic to/from the internet.
# How it Works:
#   - The Internet Gateway acts as a  tunnel or router for outbound and inbound traffic.
#   - Does not provide or generate public IPs itself—it uses the public IPs assigned to resources like EC2 instances or the EIP attached to the NAT Gateway.
#
# The Internet Gateway is necessary for both public and private subnets**:
#    - For public subnets, it enables direct access to the internet for resources with public IPs.
#    - For private subnets, it works with a NAT Gateway in the public subnet to allow indirect internet access via the NAT's Elastic IP.
# --- Security Group ---
# Configure access (firewall rules) on subnet level = NACL (default all internal communication is open)
# Configure access (firewall rules) on instance  level = Security Group (default all close)

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env_prefix}-private-subnet-${count.index}"
    Type = "private"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env_prefix}-public-subnet-${count.index}"
    Type = "public"
  }
}

# only one internet gateway per VPC because  internet gateway is attached to the VPC and not to individual subnets.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# create elastic ip for each NAT Gateway (each public subnet)
resource "aws_eip" "nat_eip" {
  count = length(var.availability_zones)

  tags = {
    Name = "${var.env_prefix}-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.env_prefix}-nat-gateway-${count.index}"
  }
}

# aws_route_table is created to allow public subnets to route their internet-bound traffic via the internet gateway.
# The route `cidr_block = "0.0.0.0/0"` defines that all outbound traffic is routed via gateway_idv(internet gateway).

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_prefix}-public-rtb"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "${var.env_prefix}-private-rtb-${count.index}"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}