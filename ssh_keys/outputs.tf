# We return a list of SSH Key names
output "ssh_key_names" {
  description = "Names of the created SSH keys"
  value       = [for key in aws_key_pair.ssh_keys : key.key_name]
}