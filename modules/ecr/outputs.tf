output "frontend_ecr_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "frontend_ecr_repository_name" {
  value = aws_ecr_repository.frontend.name
}

output "backend_ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "backend_ecr_repository_name" {
  value = aws_ecr_repository.backend.name
}
