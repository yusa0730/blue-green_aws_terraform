output "alb_private_subnet_a_id" {
  value = aws_subnet.alb_private_subnet_a.id
}

output "alb_private_subnet_c_id" {
  value = aws_subnet.alb_private_subnet_c.id
}

output "alb_private_subnet_d_id" {
  value = aws_subnet.alb_private_subnet_d.id
}

output "ecs_private_subnet_a_id" {
  value = aws_subnet.ecs_private_subnet_a.id
}

output "ecs_private_subnet_c_id" {
  value = aws_subnet.ecs_private_subnet_c.id
}

output "ecs_private_subnet_d_id" {
  value = aws_subnet.ecs_private_subnet_d.id
}
