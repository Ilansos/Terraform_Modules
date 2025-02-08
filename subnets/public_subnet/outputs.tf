# To allow other resources to be assigned to the public
# subnet we need to set an output for the public subnet id

output "public_subnet_id" {
  value = aws_subnet.public_subnet1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public_subnet2.id
}