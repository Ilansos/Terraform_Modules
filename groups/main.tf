# Create a Global Users group
# The purpouse of this group is to give basic permissions to every user in the organization
resource "aws_iam_group" "global_users" {
  name = "global_users"
  path = "/"
}

# This resource will create and administrators group
# The purpouse of this group is to give full access to AWS resources
resource "aws_iam_group" "aws_admins" {
  name = "aws_admins"
  path = "/"
}

# Now we will attach the custom "Enforce MFA Policy" to global_users group
resource "aws_iam_group_policy_attachment" "enforce_mfa_to_global_users" {
  group = aws_iam_group.global_users.name
  policy_arn = var.enforce_mfa_policy_arn
}

# Terraform does not allow to set a variable with the content of another variable
# for this reason we need to append the content of enforce_mfa_policy_arn to admin_policies_arn list
# This function was set to add the ARN of the custom policy "Enforce MFA" to the admin
# policies ARNs
locals {
  admin_policies = concat(
    [var.enforce_mfa_policy_arn], 
    var.admin_policies_arn
  )
}

# Here we attach the policies to the aws admins group
resource "aws_iam_group_policy_attachment" "attach_admin_policies_to_aws_admins_group" {
  for_each = { for idx, arn in local.admin_policies : idx => arn }
  group    = aws_iam_group.aws_admins.name
  policy_arn = each.value
}