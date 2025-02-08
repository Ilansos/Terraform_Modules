variable "vpc_configuration" {
  type = object({
    cidr = string
    enable_dns_support = bool
    enable_dns_hostnames = bool
  })
}