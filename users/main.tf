# We will create users in bulk in this module
# The users will be defines on the variable users_list that will include the usernames and the
# groups each one will be attached

# In this resource we create each user
resource "aws_iam_user" "users" {
  for_each = {for user in var.users_list : user.name => user}
  name = each.key
  tags = {
    Managed_By = "Terraform"
  }
}

# Terraform does not allow to attach several group at the same time
# For this reason we need to create a new list that maps each user to
# their respective groups. 
locals {
  # Flatten the user-group pairs into a single list of maps for each user-group combination
  user_group_pairs = flatten([
    for user in var.users_list : [
      for group in user.groups : {
        user  = user.name
        group = group
      }
    ]
  ])
}

# With this resource we will attach each user to their respective group
resource "aws_iam_group_membership" "user_groups" {
  for_each = {
    for pair in local.user_group_pairs : "${pair.user}-${pair.group}" => pair
  }

  name  = "${each.value.user}-${each.value.group}-membership"
  # Refer to the *resource* so Terraform knows to create the user first
  users = [aws_iam_user.users[each.value.user].name]

  group = each.value.group
}

# This resource will create an access key for each user
resource "aws_iam_access_key" "access_keys" {
  for_each = { for user in var.users_list : user.name => user }

  user = aws_iam_user.users[each.key].name
}


locals {
  # Build a list for each user
  # you can wrap each item in a list and then flatten.
  user_keys_list = flatten([
    for user, key in aws_iam_access_key.access_keys :
    [
      "${user},${key.id},${key.secret}"
    ]
  ])

  # Prepend the header, then join into a single CSV string
  keys_csv = join("\n", concat(
    ["username,access_key,secret_key"],
    local.user_keys_list
  ))
}

# This resource will save the access and secret keys into a csv file.
resource "local_file" "access_keys_csv" {
  content  = local.keys_csv
  filename = "keys.csv"
}
