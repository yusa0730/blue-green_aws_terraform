resource "aws_route_table" "private_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.env}-route-table-private"
  }
}

resource "aws_route_table_association" "alb_private" {
  count = length(var.alb_private_subnet_ids)

  subnet_id      = element(var.alb_private_subnet_ids, count.index)
  route_table_id = aws_route_table.private_table.id
}

resource "aws_route_table_association" "ecs_private" {
  count = length(var.ecs_private_subnet_ids)

  subnet_id      = element(var.ecs_private_subnet_ids, count.index)
  route_table_id = aws_route_table.private_table.id
}
