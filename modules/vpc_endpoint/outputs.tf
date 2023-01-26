output "vpc_endpoint_to_s3_id" {
  value = aws_vpc_endpoint.to_s3.id
}

output "vpc_endpoint_to_ecr_api_id" {
  value = aws_vpc_endpoint.to_ecr_api.id
}

output "vpc_endpoint_to_ecr_dkr_id" {
  value = aws_vpc_endpoint.to_ecr_dkr.id
}
