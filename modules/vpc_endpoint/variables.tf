variable "env" {}
variable "region" {}
variable "project_name" {}
variable "vpc_id" {}
variable "route_table_ids" {
  type = list(any)
}
variable "security_group_ids" {
  type = list(any)
}
variable "vpc_endpoint_to_ecr_subnet_ids" {
  type = list(any)
}
