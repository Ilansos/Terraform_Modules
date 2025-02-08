resource "aws_acm_certificate" "imported_certs" {
  for_each = { for idx, cert in var.ssl_certificates : idx => cert }

  private_key       = file(each.value.key_file_path)
  certificate_body  = file(each.value.crt_file_path)
  certificate_chain = file(each.value.intermediate_file_path)

  lifecycle {
    create_before_destroy = true
  }
}

