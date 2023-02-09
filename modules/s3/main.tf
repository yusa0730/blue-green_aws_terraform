resource "aws_s3_bucket" "alb_internal" {
  bucket = "${var.project_name}-${var.env}-alb-internal"

  tags = {
    Name = "${var.project_name}-${var.env}-alb-internal"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_internal_s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.alb_internal.id

  rule {
    id = "alb_internal_s3_bucket_log"

    expiration {
      days = 90
    }

    status = "Enabled"
  }
}
