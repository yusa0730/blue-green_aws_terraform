variable "alb_name" {}
variable "is_internal" {}
variable "security_group_ids" {
  type = list(any)
}
variable "subnet_ids" {
  type = list(any)
}

variable "is_enabled_to_deletion_protection" {}
variable "s3_alb_bucket" {}
variable "access_logs_prefix" {}
variable "is_enabled_to_access_logs" {}
