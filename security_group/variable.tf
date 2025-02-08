# The vpc_id variable will be defined on the global main.tf file
# It will be extracted from the vpc module
variable "vpc_id" {
  type = string
}

# This variable will be used as an IP range that will be able to connect via SSH to the instance
variable "ssh_allow_cidr" {
  default = ["1.1.1.1/32"] # This is the Cloudflare DNS IP, replace it with the CIDR you need
}

# This variable will be used as an IP range that will be able to ping the instance
variable "icmp_allow_cidr" {
  default = ["1.1.1.1/32"] # This is the Cloudflare DNS IP, replace it with the CIDR you need
}

variable "my_ip_cidr" {
  type = list(string)
  default = ["1.1.1.1/32"]
}