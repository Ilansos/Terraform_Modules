# The vpc_id variable will be defined on the global main.tf file
variable "vpc_id" {
  type = string
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
}