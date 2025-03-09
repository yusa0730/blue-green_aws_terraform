resource "aws_cloudwatch_log_group" "awslogs_bastion" {
  name              = "/aws/ecs/awslogs/${local.name}/bastion"
  retention_in_days = var.logs_retention_in_days

  tags = {
    Name = "/aws/ecs/awslogs/${local.name}/bastion"
  }
}

resource "aws_cloudwatch_log_group" "containerinsights" {
  name              = "/aws/ecs/containerinsights/${local.name}/performance"
  retention_in_days = 1

  tags = {
    Name = local.name
  }
}

resource "aws_ecs_cluster" "main" {
  name = local.name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights
  }

  tags = {
    Name = local.name
  }
}

# resource "aws_ecs_service" "main" {
#   name             = local.name
#   cluster          = aws_ecs_cluster.main.id
#   task_definition  = aws_ecs_task_definition.main.arn
#   launch_type      = "FARGATE"
#   platform_version = "1.4.0"
#   desired_count    = var.desired_count
#   #health_check_grace_period_seconds = 0
#   enable_execute_command  = true
#   enable_ecs_managed_tags = true
#   network_configuration {
#     subnets         = var.ecs_subnet_ids
#     security_groups = var.ecs_sg_ids
#   }

#   tags = {
#     Name = local.name
#   }

#   lifecycle {
#     ignore_changes = [
#       task_definition,
#       desired_count,
#       load_balancer
#     ]
#   }
# }

resource "aws_ecs_task_definition" "main" {
  family                   = local.name
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = <<EOL
[
  {
    "name": "${var.name_suffix}",
    "image": "${var.image}",
    "linuxParameters": {
      "initProcessEnabled": true
    },
    "pseudoTerminal": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.awslogs_bastion.name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOL

  tags = {
    Name = local.name
  }
}
