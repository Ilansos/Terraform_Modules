output "bucket_ids" {
  description = "The IDs of the S3 buckets"
  value = { for name, bucket in aws_s3_bucket.s3_buckets : name => bucket.id }
}

output "bucket_arns" {
  description = "The ARNs of the S3 buckets"
  value = { for name, bucket in aws_s3_bucket.s3_buckets : name => bucket.arn }
}

output "bucket_names" {
  description = "The names of the S3 buckets"
  value = { for name, bucket in aws_s3_bucket.s3_buckets : name => bucket.bucket }
}