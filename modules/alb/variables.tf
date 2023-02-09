variable "project_name" {}
variable "env" {}
variable "security_group_ids" {
  type = list(any)
}
variable "security_group_internal_ids" {
  type = list(any)
}
variable "public_subnet_ids" {
  type = list(any)
}
variable "private_subnet_ids" {
  type = list(any)
}
variable "s3_alb_bucket" {}
variable "s3_alb_internal_bucket" {}

