variable "ssl_certificates" {
  type = list(object({
    key_file_path = string
    crt_file_path = string
    intermediate_file_path = string
  }))
}