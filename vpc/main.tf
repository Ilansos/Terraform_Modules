#############################################################
# - This module creates a basic VPC with a CIDR Block that  #
#   is set up on the variable.tf file in this directory     #
# - It outputs the VPC ID so other resources can use it     #
#############################################################

resource "aws_vpc" "example_vpc" {
  cidr_block = var.vpc_cidr
}