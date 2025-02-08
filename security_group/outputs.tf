# In order for other assets to be able to use the security group
# we need to set the ID of the security group as an output

output "allow_ssh_and_ping_security_group_id" {
  value = aws_security_group.allow_ssh_and_ping.id
}

output "sg_for_elb_id" {
  value = aws_security_group.sg_for_elb.id
}

output "sg_allow_from_elb_id" {
  value = aws_security_group.sg_allow_from_elb.id
}

output "postgres_sg_id" {
  value = aws_security_group.postgres_security_group.id
}