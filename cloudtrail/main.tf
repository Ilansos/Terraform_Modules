# This resource will create a trail in cloudtrail
resource "aws_cloudtrail" "global_cloudtrail" {
  # This will set the name of the trail
  name = var.cloudtrail_configuration.cloudtrail_name
  # Here we set the bucket that will store the logs
  s3_bucket_name = var.cloudtrail_s3_bucket_name
  # We set other cloudtrail configurations
  include_global_service_events = var.cloudtrail_configuration.include_global_service_events
  is_multi_region_trail = var.cloudtrail_configuration.is_multi_region_trail
  enable_logging = var.cloudtrail_configuration.enable_logging
  event_selector {
    read_write_type = var.cloudtrail_configuration.event_selector.read_write_type
    include_management_events = var.cloudtrail_configuration.event_selector.include_management_event
  }
  # We set the depends_on function so first will create the policy allowing cloudtrail
  # to write into the s3 bucket
  depends_on = [ aws_s3_bucket_policy.cloudtrain_bucket_policy ]
}

# This resource will create a policy that will allow cloudtrail to write into the s3 bucket
resource "aws_s3_bucket_policy" "cloudtrain_bucket_policy" {
  bucket = var.cloudtrail_s3_bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${var.cloudtrail_s3_bucket_name}"
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "arn:aws:s3:::${var.cloudtrail_s3_bucket_name}/AWSLogs/${var.aws_account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}