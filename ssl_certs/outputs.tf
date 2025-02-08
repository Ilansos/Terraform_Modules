output "ssl_certificate_arns" {
  value = { for idx, cert in aws_acm_certificate.imported_certs : idx => cert.arn }
}
