resource "aws_lb_listener" "listener_blue" {
  load_balancer_arn = var.alb_internal_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_blue_arn
  }
}

resource "aws_lb_listener" "listener_green" {
  load_balancer_arn = var.alb_internal_arn
  port              = 10080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_green_arn
  }
}
