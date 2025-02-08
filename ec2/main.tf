#############################################################################
# In this module I will upload an SSH Key from my host to AWS, use that key #
# on 2 different EC2 instances that will be located inside a Public Subnet  #
#############################################################################


resource "aws_instance" "terraform_ec2" {
  for_each = { for idx, instance in var.ec2_instances : idx => instance }
  ami                     = each.value.ami
  instance_type           = each.value.instance_type
  key_name                = each.value.key_name
  vpc_security_group_ids  = each.value.vpc_security_group_ids
  subnet_id               = each.value.subnet_id
  private_ip              = each.value.private_ip

  root_block_device {
    volume_size = each.value.root_volume_size
    volume_type = each.value.volume_type # Optional: Set volume type (gp3, gp2, io1, etc.)
    delete_on_termination = each.value.delete_on_termination
  }

  tags = each.value.tags
  
}
