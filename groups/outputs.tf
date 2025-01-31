# We set the name of the global_user group as an output to 
# allow users to be added to this group on a different module
output "global_users_name" {
  value = aws_iam_group.global_users.name
}

# We set the name of the aws_admins group as an output to 
# allow users to be added to this group on a different module
output "aws_admins_name" {
  value = aws_iam_group.aws_admins.name
}