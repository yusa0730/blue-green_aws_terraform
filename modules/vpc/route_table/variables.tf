variable "vpc_id" {}
variable "env" {}
variable "project_name" {}

variable "alb_private_subnet_ids" {
  description = "List of ALB private subnet IDs"
  type        = list(string)
}

variable "ecs_private_subnet_ids" {
  description = "List of ECS private subnet IDs"
  type        = list(string)
}
