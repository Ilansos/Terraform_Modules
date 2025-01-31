# To allow other resources to be assigned to the public
# subnet we need to set an output for the public subnet id

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}