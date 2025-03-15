# A VPC is a virtual (isolated) network in AWS.
# To host resources in the VPC (like EC2 instances), you must create subnets.
# A subnet is a range of IP addresses in the VPC assigned to resources within a specific availability zone.
# An availability zone is an isolated data center in a particular AWS region, designed to be independent of failures in other zones.
# Subnets Are Tied to Availability Zones**:
# --- Internet Gateway ---
# Firewall rule configuration makes it either a private or public subnet
# internet gateway (IGW) - connects the VPC to the outside internet
# Public Subnet- A subnet that has a route to the internet through an internet gateway (IGW).
# Typically used for resources like web servers that need to be accessible over the internet.
# Private Subnet - A subnet without direct internet access. Usually, traffic is routed to the internet through a NAT Gateway in a public subnet.
# Used for sensitive resources like databases or application servers.
# --- Security Group ---
# Configure access (firewall rules) on subnet level = NACL
# Configure access (firewall rules) on instance  level = Security Group