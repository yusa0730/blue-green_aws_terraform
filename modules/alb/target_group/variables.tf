variable "target_group_name" {}
variable "target_group_port" {
  default = 80
}
variable "target_group_protocol" {
  default = "HTTP"
}
variable "target_group_target_type" {
  default = "ip"
}
variable "is_enabled_to_health_check" {
  default = true
}
variable "vpc_id" {}
variable "healthy_threshold_count" {
  default = 3
}
variable "health_check_interval" {
  default = "30"
}
variable "health_check_matcher" {
  default = "200"
}
variable "health_check_path" {
  default = "/health"
}
variable "health_check_port" {
  default = "traffic-port"
}
variable "health_check_protocol" {
  default = "HTTP"
}
variable "health_check_timeout" {
  default = "5"
}
variable "health_check_unhealthy_threshold_count" {
  default = "2"
}
