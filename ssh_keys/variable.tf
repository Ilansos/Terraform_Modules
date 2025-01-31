# This variable is used to give a list of SSH keys and their respective local path
variable "ssh_keys" {
  description = "List of ssh key names and local paths of the SSH keys you want to upload to AWS"
  type = list(object({
    name = string
    path = string
  }))
  default = [ {
    name = "Main SSH Key"
    path = "/path/for/your/ssh/pub/key1"
  },
  {
    name = "Second SSH Key"
    path = "/path/for/your/ssh/pub/key2"
  }
  ]
}