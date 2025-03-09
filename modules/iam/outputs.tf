output "ecs_task_execution_iar_arn" {
  value = aws_iam_role.ecs_task_execution_iar.arn
}

output "bastion_ecs_task_iar_arn" {
  value = aws_iam_role.bastion_ecs_task_iar.arn
}

output "ecs_code_deploy_iar_arn" {
  value = aws_iam_role.ecs_code_deploy_iar.arn
}
