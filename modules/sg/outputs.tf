output "public_alb_sg_id" {
  value = aws_security_group.public_alb.id
}

output "front_container_sg_id" {
  value = aws_security_group.front_container.id
}

output "internal_alb_sg_id" {
  value = aws_security_group.internal_alb.id
}

output "container_sg_id" {
  value = aws_security_group.container.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

output "vpce_sg_id" {
  value = aws_security_group.vpce.id
}

output "management_sg_id" {
  value = aws_security_group.management.id
}
