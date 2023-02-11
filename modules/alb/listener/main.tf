resource "aws_lb_listener" "main" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port_number
  protocol          = var.protocol

  default_action {
    type             = var.action_type
    target_group_arn = var.target_group_arn
  }
}
