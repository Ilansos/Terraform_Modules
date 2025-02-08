# The vpc_id variable will be defined on the global main.tf file
variable "vpc_id" {
  type = string
}

variable "public_subnet1_cidr" {
  default = "10.0.0.0/24"
}

variable "public_subnet_1_availability_zone" {
  type = string
}

variable "public_subnet2_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2_availability_zone" {
  type = string
}