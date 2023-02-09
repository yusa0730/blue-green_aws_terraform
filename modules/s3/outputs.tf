output "alb_internal_s3_bucket_id" {
  value = aws_s3_bucket.alb_internal.id
}

output "alb_internal_s3_bucket_arn" {
  value = aws_s3_bucket.alb_internal.arn
}
