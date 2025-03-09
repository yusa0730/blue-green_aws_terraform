output "alb_s3_bucket_id" {
  value = aws_s3_bucket.alb_access_logs.id
}

output "alb_s3_bucket_arn" {
  value = aws_s3_bucket.alb_access_logs.arn
}
