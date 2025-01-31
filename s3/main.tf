resource "aws_s3_bucket" "s3_buckets" {
  for_each = {for bucket in var.buckets : bucket.name => bucket }
  bucket = each.value.name
  force_destroy = each.value.force_destroy
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  for_each = { for bucket in var.buckets : bucket.name => bucket }

  bucket = aws_s3_bucket.s3_buckets[each.key].id
  versioning_configuration {
    status = each.value.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  for_each = { for bucket in var.buckets : bucket.name => bucket }

  bucket = aws_s3_bucket.s3_buckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = each.value.sse_algorithm
    }
  }
}