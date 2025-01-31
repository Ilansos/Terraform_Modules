###########################################################################
# If you want to create an Private Subnet with internet access (a         #
# subnet that each device will be behind NAT Gateway), this means that    #
# each device will have only an private IP                                #
# - We need to deploy a NAT Gateway on a public subnet (So it can have    #
# an Public IP)                                                           #
###########################################################################


# First we need to request an Elastic IP for the Nat Gateway
resource "aws_eip" "elastic_ip_for_nat" {
  # Here we set that the Elastic IP will be used inside the VPC
  domain = "vpc"
  # Here we add the tags we want
  tags = {
    Name = "Elastic_IP_for_Nat_Gateway"
  }
}

# Second we create the Nat Gateway
resource "aws_nat_gateway" "private_subnet_nat_gateway" {
  # We give him the Elastic IP we requested on the First Step
  allocation_id = aws_eip.elastic_ip_for_nat.id
  # Here we assign the nat gateway to be inside the public subnet
  subnet_id = var.public_subnet_id
  # We can add a tag
  tags = {
    Name = "Private_Subnet_Nat_Gateway"
  }
}

# Third we create a private subnet
# This subnet needs to be inside of the VPC subnet but outside the Public Subnet
resource "aws_subnet" "private_subnet" {
  # Here we assign it to the correct VPC
  vpc_id = var.vpc_id
  # Here we assign the IP range for this subnet
  # We take it from the variable.tf file in this folder
  cidr_block = var.private_subnet_cidr
  # Optionally we can set up a specific availability zone for this subnet
  availability_zone = var.private_subnet_availability_zone
  # We can also set a tag
  tags = {
    Name = "Private_Subnet_Availability_zone"
  }
}

# Fourth we need to create a Route Table to access the internet
# This will route all the traffic to the Nat Gateway so the instances can access the internet
resource "aws_route_table" "private_subnet_route_table" {
  # We assign the route table to our VPC
  vpc_id = var.vpc_id
  # Here we establish the default route
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private_subnet_nat_gateway.id
  }
  # We can also add a tag
  tags = {
    Name = "Private_Subnet_Route_Table"
  }
}

# Fifth we need to asociate the Route Table to the Private Subnet
resource "aws_route_table_association" "private_subnet_route_table_association" {
  # We set the subnet that we want to asociate the route table
  subnet_id = aws_subnet.private_subnet.id
  # We need to specify which route table we want to associate to the subnet
  route_table_id = aws_route_table.private_subnet_route_table.id
}