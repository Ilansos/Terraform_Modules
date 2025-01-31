#############################################################
# To create a public subnet we need:                        #
# - Set a CIDR Block inside the main VPC CIDR               #
# - map_public_ip_on_launch = true                          #
# - Create an Internet Gateway                              #
# - Create a route gateway for default route (0.0.0.0/0)    #            
# - Associate the Route Table to the Public Subnet          #
#############################################################

resource "aws_subnet" "public_subnet" {
  # This variable will take the output of the VPC module
  # We will configure to take the relevant output on the main.tf file of the main project
  vpc_id = var.vpc_id
  # We configured the content of this variable on the variable.tf file in this folder
  cidr_block = var.public_subnet_cidr
  # We set that every instance in this subnet will receive a public IP on Launch
  map_public_ip_on_launch = true
  # We set the tags we want to add to this subnet
  tags = {
    Name = "Public_Subnet"
  }
}

# Here we create an internet gateway for this subnet
resource "aws_internet_gateway" "public_subnet_igw" {
  # We only need to assign it to the VPC
  vpc_id = var.vpc_id
}

# Here we create a route table to allow internet access
# It will route all the traffic to the Internet Gateway
resource "aws_route_table" "public_subnet_route_table" {
  # Here we assign the route table to the VPC
  vpc_id = var.vpc_id
  # Here we route the traffic to the internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_subnet_igw.id
  }
}

# Here we associate the route table to the public subnet
resource "aws_route_table_association" "public_subnet_association" {
  # We need to give the correct id of the public subnet
  subnet_id = aws_subnet.public_subnet.id
  # We also need to give the correct id of the route table
  route_table_id = aws_route_table.public_subnet_route_table.id
}