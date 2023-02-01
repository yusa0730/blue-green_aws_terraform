variable "env" {}
variable "region" {}
variable "project_name" {}
variable "vpc_id" {}
variable "private_table_id" {}
variable "sg_vpc_endpoint_id" {}
variable "vpc_endpoint_to_ecr_subnet_ids" {
  type = list(any)
}
