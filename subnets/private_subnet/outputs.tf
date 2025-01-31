# To allow other resources to be assigned to the private
# subnet we need to set an output for the private subnet id

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}