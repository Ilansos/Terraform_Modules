#############################################################################
# In this module I will upload an SSH Key from my host to AWS, use that key #
# on 2 different EC2 instances that will be located inside a Public Subnet  #
#############################################################################


# # First we will upload the SSH Key to AWS
# resource "aws_key_pair" "main_ssh_key" {
#   key_name = "main_ssh_key"
#   # We set the public key to be extracted from a file on the 
#   # path we set in the variable.tf file
#   public_key = file(var.ssh_key_path)
# }

# # Now we will create the EC2 instances
# # The ammount will be set on the variable.tf file
# resource "aws_instance" "terraform_ec2" {
#   # Use the count argument to create multiple instances
#   count = var.instances_count 
#   # We set the AMi we defined in variable.tf file
#   ami = var.ami_id
#   # We set the Instance Type we defined in variable.tf file
#   instance_type = var.instance_type
#   # We set the SSH key we uploaded on the previous step
#   key_name = aws_key_pair.main_ssh_key.key_name
#   # We set the security groups from the security group module
#   vpc_security_group_ids = [var.security_group_id]
#   # We set the public subnet id from the public subnet module
#   subnet_id = var.public_subnet_id
#   # We use the format method to set each instance IP to be the count index + 10
#   private_ip = format("10.0.0.%d", count.index + 10)
#   # Create a unique name for each instance
#   tags = {
#     Name = "Terraform_EC2_Public_Subnet_${count.index + 1}" 
#   }
# }

resource "aws_instance" "terraform_ec2" {
  for_each = { for idx, instance in var.ec2_instances : idx => instance }
  ami                     = each.value.ami
  instance_type           = each.value.instance_type
  key_name                = each.value.key_name
  vpc_security_group_ids  = each.value.vpc_security_group_ids
  subnet_id               = each.value.subnet_id
  private_ip              = each.value.private_ip


  tags = each.value.tags
  
}
