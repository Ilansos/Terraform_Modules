# This variable is the output of the global_user group name
variable "global_users_name" {
  type = string
}

# This variable is the output of the aws_admins group name
variable "aws_admins_name" {
  type = string
}

# This variable will define the users to create and into which groups should
# them be attached to
variable "users_list" {
  type = list(object({
    name    = string
    groups  = list(string)
  }))
}