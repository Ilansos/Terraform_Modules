buckets = [ {
    name = "test.cloudtrail.bucket"
    acl = "private"
    enable_versioning = false
    force_destroy = true
    sse_algorithm = "AES256"
    tags = {
      Name = "S3_1"
    }
  } 
  ]

cloudtrail_configuration = {
  cloudtrail_name = "test-cloudtrail"
  include_global_service_events = true
  is_multi_region_trail = true
  enable_logging = true
  event_selector = {
    read_write_type = "All"
    include_management_event = true
  }
}

ssh_keys = [{
  name = "test_ssh_key"
  path = "/path/to/your/pub/ssh/key"
}]