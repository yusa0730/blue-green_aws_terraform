resource "aws_cloudwatch_log_group" "awslogs_frontend" {
  name              = "/aws/ecs/awslogs/${local.name}"
  retention_in_days = var.logs_retention_in_days

  tags = {
    Name = "/aws/ecs/awslogs/${local.name}"
  }
}

resource "aws_cloudwatch_log_group" "containerinsights" {
  name              = "/aws/ecs/containerinsights/${local.name}/performance"
  retention_in_days = 1

  tags = {
    Name = local.name
  }
}

## ECS
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

resource "aws_ecs_service" "main" {
  name    = "${local.name}-service"
  cluster = aws_ecs_cluster.main.id

  load_balancer {
    container_name   = "frontend"
    container_port   = "80"
    target_group_arn = var.targetgroup_80_arn
  }

  task_definition  = aws_ecs_task_definition.main.arn
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  desired_count    = var.desired_count
  #health_check_grace_period_seconds = 0
  enable_execute_command  = true
  enable_ecs_managed_tags = true

  network_configuration {
    assign_public_ip = false
    subnets          = var.ecs_subnet_ids
    security_groups  = var.ecs_sg_ids
  }

  tags = {
    Name = local.name
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      load_balancer
    ]
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${local.name}-taskdef"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      "cpu" : 256,
      "memory" : 512,
      "name" : "frontend",
      "image" : "${var.ecr_repository_url}:latest",
      "portMappings" : [
        {
          "protocol" : "tcp"
          "containerPort" : 80
          "hostPort" : 80
        }
      ],
      "environment" : [
        {
          "name" : "SESSION_SECRET_KEY",
          "value" : "41b678c65b37bf99c37bcab522802760"
        },
        {
          "name" : "APP_SERVICE_HOST",
          "value" : "http://${var.alb_dns_name}"
        },
        {
          "name" : "NOTIF_SERVICE_HOST",
          "value" : "http://${var.alb_dns_name}"
        },
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.awslogs_frontend.name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "ecs",
        }
      },
      "stopTimeout" : 2,
      "readonlyRootFilesystem" : true,
      "linuxParameters" : {
        "initProcessEnabled" : false
      },
      "volumesFrom" : [],
      "essential" : true,
      "mountPoints" : [],
      "systemControls" : []
    }
  ])

  tags = {
    Name = local.name
  }
}
