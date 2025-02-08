#############################################################
# - This module creates a basic VPC with a CIDR Block that  #
#   is set up on the variable.tf file in this directory     #
# - It outputs the VPC ID so other resources can use it     #
#############################################################

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_configuration.cidr
  enable_dns_support   = var.vpc_configuration.enable_dns_support # Enables DNS resolution
  enable_dns_hostnames = var.vpc_configuration.enable_dns_hostnames  # Enables DNS hostnames
}