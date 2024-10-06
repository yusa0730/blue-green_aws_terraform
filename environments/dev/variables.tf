variable "project_name" {
  type    = string
  default = "container-test"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "aws_default_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "alb_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.0.0/24",
    "10.0.1.0/24"
  ]
}

variable "app_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.8.0/24",
    "10.0.9.0/24"
  ]
}

variable "aurora_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.16.0/24",
    "10.0.17.0/24"
  ]
}

variable "bastion_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.240.0/24"
  ]
}

variable "endpoint_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.248.0/24",
    "10.0.249.0/24"
  ]
}
