output "ec2_instance_ids" {
  description = "List of EC2 instance IDs"
  value       = values(aws_instance.terraform_ec2)[*].id
}
