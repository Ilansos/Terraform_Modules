output "user_group_pairs" {
  value = local.user_group_pairs
}

output "access_keys" {
  value = tomap({
    for username, key in aws_iam_access_key.access_keys :
    username => {
      access_key_id     = key.id
      secret_access_key = key.secret
    }
  })
  sensitive = true
}