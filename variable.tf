variable "buckets" {
    type = list(object({
      name = string
      acl = string
      enable_versioning = bool
      force_destroy = bool
      sse_algorithm = string
      tags = map(string)
    }))
}

variable "cloudtrail_configuration" {
  type = object({
    cloudtrail_name = string
    include_global_service_events = bool
    is_multi_region_trail = bool
    enable_logging = bool
    event_selector = object({
      read_write_type = string
      include_management_event = bool
    })
  })
}

variable "ssh_keys" {
  description = "List of ssh key names and local paths of the SSH keys you want to upload to AWS"
  type = list(object({
    name = string
    path = string
  }))
}

variable "my_ip_cidr" {
  type = list(string)
}

variable "ssl_certificates" {
  type = list(object({
    key_file_path = string
    crt_file_path = string
    intermediate_file_path = string
  }))
}

variable "postgress_user" {
  type = string
  sensitive = true
}

variable "postgres_password" {
  type = string
  sensitive = true
}

variable "vpc_configuration" {
  type = object({
    cidr = string
    enable_dns_support = bool
    enable_dns_hostnames = bool
  })
}