variable "buckets" {
    type = list(object({
      name = string
      acl = string
      enable_versioning = bool
      force_destroy = bool
      sse_algorithm = string
      tags = map(string)
    }))
    default = [ {
      name = "S3_bucket"
      acl = "private"
      enable_versioning = false
      force_destroy = false
      sse_algorithm = "AES256"
      tags = {
        "Name" = "S3_bucket"
      }
    } ]
}