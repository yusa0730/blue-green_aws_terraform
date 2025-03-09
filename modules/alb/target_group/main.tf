resource "aws_lb_target_group" "main" {
  name                          = var.target_group_name
  port                          = var.target_group_port
  protocol                      = var.target_group_protocol
  protocol_version              = var.target_group_protocol_version
  target_type                   = var.target_group_target_type
  vpc_id                        = var.vpc_id
  load_balancing_algorithm_type = var.load_balancing_algorithm_type

  health_check {
    enabled             = var.is_enabled_to_health_check
    healthy_threshold   = var.healthy_threshold_count
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold_count
  }
}
