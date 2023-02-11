variable "load_balancer_arn" {}
variable "port_number" {
  default = 80
}
variable "protocol" {
  default = "HTTP"
}
variable "action_type" {
  default = "forward"
}
variable "target_group_arn" {}
