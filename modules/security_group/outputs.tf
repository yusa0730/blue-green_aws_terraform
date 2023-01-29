output "sg_ingress_id" {
  value = aws_security_group.ingress.id
}

output "sg_management_id" {
  value = aws_security_group.management.id
}

output "sg_container_id" {
  value = aws_security_group.container.id
}

output "sg_front_container_id" {
  value = aws_security_group.front_container.id
}

output "sg_alb_internal_id" {
  value = aws_security_group.alb_internal.id
}

output "sg_db_id" {
  value = aws_security_group.db.id
}

output "sg_vpc_endpoint_id" {
  value = aws_security_group.vpc_endpoint.id
}
