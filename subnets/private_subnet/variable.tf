# The public_subnet_id variable will be defined on the global main.tf file
# It will be extracted from the public_subnet module
variable "public_subnet_id" {
    type = string
}

# The vpc_id variable will be defined on the global main.tf file
# It will be extracted from the vpc module
variable "vpc_id" {
  type = string
}

# This variable will be used to set the CIDR of the Private Subnet
# As a reminder I set VPC to have a CIDR of 10.0.0.0/16
# As a reminder I set public subnet to have a CIDR of 10.0.1.0/16
variable "private_subnet_cidr" {
  default = "10.0.1.0/24"
}

# This variable is used to set the availability zone that we want the private subnet to be in
variable "private_subnet_availability_zone" {
  default = "il-central-1c"
}