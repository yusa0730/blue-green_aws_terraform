variable "project_name" {}
variable "env" {}
variable "logs_retention_in_days" {}
variable "enable_container_insights" {}
variable "desired_count" {}
variable "ecs_subnet_ids" {}
variable "ecs_sg_ids" {
  type = list(string)
}
variable "name_suffix" {}
variable "image" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
