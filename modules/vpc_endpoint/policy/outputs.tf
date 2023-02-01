output "to_s3_policy_id" {
  value = aws_vpc_endpoint_policy.to_s3_policy.id
}

output "to_ecr_api_policy_id" {
  value = aws_vpc_endpoint_policy.to_ecr_api_policy.id
}

output "to_ecr_dkr_policy_id" {
  value = aws_vpc_endpoint_policy.to_ecr_dkr_policy.id
}
