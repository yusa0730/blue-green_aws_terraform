resource "aws_lb" "main" {
  name                             = var.alb_name
  internal                         = var.is_internal
  load_balancer_type               = var.load_balancer_type
  security_groups                  = var.security_group_ids
  subnets                          = var.subnet_ids
  enable_http2                     = "true"
  enable_cross_zone_load_balancing = "true"
  ip_address_type                  = "ipv4"
  desync_mitigation_mode           = "defensive"

  enable_deletion_protection = var.is_enabled_to_deletion_protection

  access_logs {
    bucket  = var.s3_alb_bucket
    prefix  = var.access_logs_prefix
    enabled = var.is_enabled_to_access_logs
  }

  tags = {
    Name = var.alb_name
  }
}
