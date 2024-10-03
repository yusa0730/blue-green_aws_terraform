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

variable "ecs_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.0.0/22",
    "10.0.4.0/22",
  ]
}

variable "alb_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.164.0/24",
    "10.0.165.0/24",
    "10.0.166.0/24"
  ]
}

variable "aurora_cidr_blocks" {
  type = list(string)
  default = [
    "10.0.248.128/27",
    "10.0.248.192/27"
  ]
}
