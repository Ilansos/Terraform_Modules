output "rds_hostname" {
  description = "RDS instance Hostname"
  value = aws_db_instance.postgress.address
  sensitive = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.postgress.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.postgress.username
  sensitive   = true
}
