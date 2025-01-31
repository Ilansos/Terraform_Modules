# In order for other assets to be able to use the security group
# we need to set the ID of the security group as an output

output "allow_ssh_and_ping_security_group_id" {
  value = aws_security_group.allow_ssh_and_ping.id
}