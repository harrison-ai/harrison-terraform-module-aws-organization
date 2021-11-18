resource "aws_s3_bucket" "this" {
  provider = aws.audit

  bucket = var.bucket_name
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "transition-to-IA"
    enabled = true
    transition {
      days          = var.transition_to_ia_days
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "expiration"
    enabled = true
    expiration {
      # 7 years
      days = var.expiration_days
    }
  }

  lifecycle_rule {
    id                                     = "abort-incomplete-multipart-upload"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 30
  }

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  provider = aws.audit

  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.this
  ]
}

resource "aws_s3_bucket_policy" "this" {
  provider = aws.audit

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket.json

  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_public_access_block.this
  ]
}

resource "aws_cloudtrail" "this" {
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.this.id
  kms_key_id                    = aws_kms_key.this.arn
  include_global_service_events = true
  is_organization_trail         = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    include_management_events = true
    read_write_type           = "All"
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}

resource "aws_kms_key" "this" {
  description = "KMS Key for Org CloudTrail"
  policy      = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "this" {
  name          = "alias/cloudtrail"
  target_key_id = aws_kms_key.this.key_id
}
