variable "alb_name" {
  type = string
}
variable "is_internal" {
  default = false
}
variable "security_group_ids" {
  type = list(any)
}
variable "subnet_ids" {
  type = list(any)
}

variable "is_enabled_to_deletion_protection" {
  default = false
}
variable "s3_alb_bucket" {}
variable "access_logs_prefix" {}
variable "is_enabled_to_access_logs" {
  default = true
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}
