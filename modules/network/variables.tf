variable "subnet_zone_id" {
  type    = list(any)
  default = ["a", "c"]
}

variable "route_table_zone_id" {
  type    = list(any)
  default = ["a", "c"]
}

variable "alb_cidr_blocks" {
  type = list(string)
}

variable "container_cidr_blocks" {
  type = list(string)
}

variable "aurora_cidr_blocks" {
  type = list(string)
}

# variable "ecr_sg_id" {
#   type = string
# }

# variable "logs_sg_id" {
#   type = string
# }

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}
