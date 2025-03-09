output "public_alb_subnet_ids" {
  value = aws_subnet.public_alb[*].id
}

output "private_app_subnet_ids" {
  value = aws_subnet.private_app[*].id
}

output "bastion_subnet_ids" {
  value = aws_subnet.private_bastion[*].id
}

output "aurora_subnet_ids" {
  value = aws_subnet.private_aurora[*].id
}
