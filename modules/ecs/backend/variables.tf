variable "project_name" {}
variable "env" {}
variable "region" {}
variable "logs_retention_in_days" {}
variable "enable_container_insights" {}
variable "desired_count" {}
variable "ecs_subnet_ids" {}
variable "ecs_sg_ids" {
  type = list(string)
}
variable "name_suffix" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "ecs_codedeploy_group_service_arn" {}
variable "lb_listener_http_80_arn" {}
variable "lb_listener_http_10080_arn" {}
variable "targetgroup_80_name" {}
variable "targetgroup_10080_name" {}
variable "ecr_repository_url" {}
variable "targetgroup_80_arn" {}
variable "vpc_id" {}
