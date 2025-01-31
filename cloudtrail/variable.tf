variable "cloudtrail_s3_bucket_name" {
  type = string
}

variable "aws_account_id" {
  description = "The AWS Account ID for the CloudTrail logs."
  type        = string
}

variable "cloudtrail_configuration" {
  type = object({
    cloudtrail_name = string
    include_global_service_events = bool
    is_multi_region_trail = bool
    enable_logging = bool
    event_selector = object({
      read_write_type = string
      include_management_event = bool
    })
  })
}