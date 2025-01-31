######################################################################
# In this module we will upload SSH keys to AWS so we can use them   #
# to connect to EC2 instances                                        #
######################################################################

resource "aws_key_pair" "ssh_keys" {
  # We make a loop to create each ssh key
  for_each = {for idx, ssh_key in var.ssh_keys : idx => ssh_key}
  # We set each key name
  key_name = each.value.name
  # We set the local path of each key we want to upload
  public_key = file(each.value.path)
}