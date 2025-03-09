resource "aws_s3_bucket" "alb_access_logs" {
  bucket        = var.bucket_name
  force_destroy = var.is_destroyed

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "access_block_against_porta_api_log_s3" {
  bucket = aws_s3_bucket.alb_access_logs.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.alb_access_logs.id

  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.alb_access_logs.id

  rule {
    id = var.lifecycle_id

    expiration {
      days = var.expiration_days
    }

    status = var.lifecycle_status
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.alb_access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.alb_access_logs.bucket

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

// elb-account-idは、ドキュメントにも記載がありますが、東京リージョンの場合、582318560864
resource "aws_s3_bucket_policy" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.bucket
  policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "s3:PutObject",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::582318560864:root"
          },
          "Resource": "arn:aws:s3:::${aws_s3_bucket.alb_access_logs.bucket}/*"
        }
      ]
    }
    POLICY
}


## イベント通知用
# resource "aws_s3_bucket_notification" "main" {
#   bucket = aws_s3_bucket.main.bucket

#   topic {
#     topic_arn = var.sns_topic_s3_event_arn
#     events    = ["s3:ObjectRemoved:*"]
#   }
# }
