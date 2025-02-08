# This variable is to define each EC2 we want to deploy
variable "ec2_instances" {
  type = list(object({
    ami = string
    instance_type = string
    key_name = string
    vpc_security_group_ids = list(string)
    subnet_id = string
    private_ip = string
    root_volume_size = number
    volume_type = string
    delete_on_termination = bool
    tags = map(string)
  }))
}