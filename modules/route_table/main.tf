resource "aws_route_table" "private_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.env}-route-table-private"
  }
}

resource "aws_route_table_association" "alb_private_a" {
  subnet_id      = var.alb_private_subnet_a_id
  route_table_id = aws_route_table.private_table.id
}

resource "aws_route_table_association" "alb_private_c" {
  subnet_id      = var.alb_private_subnet_c_id
  route_table_id = aws_route_table.private_table.id
}

resource "aws_route_table_association" "alb_private_d" {
  subnet_id      = var.alb_private_subnet_d_id
  route_table_id = aws_route_table.private_table.id
}

resource "aws_route_table_association" "ecs_private_a" {
  subnet_id      = var.ecs_private_subnet_a_id
  route_table_id = aws_route_table.private_table.id
}

resource "aws_route_table_association" "ecs_private_c" {
  subnet_id      = var.ecs_private_subnet_c_id
  route_table_id = aws_route_table.private_table.id
}

resource "aws_route_table_association" "ecs_private_d" {
  subnet_id      = var.ecs_private_subnet_d_id
  route_table_id = aws_route_table.private_table.id
}
