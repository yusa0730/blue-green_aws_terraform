variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "subnet_zone_id" {
  type    = list(any)
  default = ["a", "c"]
}

variable "route_table_zone_id" {
  type    = list(any)
  default = ["a", "c"]
}

variable "vpce_sg_id" {
  type = string
}

variable "alb_cidr_blocks" {
  type = list(string)
}

variable "app_cidr_blocks" {
  type = list(string)
}

variable "aurora_cidr_blocks" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "endpoint_cidr_blocks" {
  type = list(string)
}

variable "bastion_cidr_blocks" {
  type = list(string)
}
