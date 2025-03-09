resource "aws_cloudwatch_log_group" "awslogs_backend" {
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

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    container_name   = "app"
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

  service_registries {
    registry_arn = aws_service_discovery_service.main.arn
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
  }

  container_definitions = jsonencode([
    {
      "cpu" : 256,
      "memory" : 512,
      "name" : "app",
      "image" : "${var.ecr_repository_url}:latest",
      "portMappings" : [
        {
          "protocol" : "tcp"
          "containerPort" : 80
          "hostPort" : 80
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.awslogs_backend.name}",
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

## AWS Cloud Map
resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "local"
  description = "local"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "main" {
  name = "${local.name}-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

## CODE DEPLOY
resource "aws_codedeploy_app" "main" {
  compute_platform = "ECS"
  name             = "${local.name}-cluster-${local.name}-bluegreen-service"
}

resource "aws_codedeploy_deployment_group" "main" {
  app_name                    = aws_codedeploy_app.main.name
  autoscaling_groups          = []
  deployment_config_name      = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name       = "${local.name}-bluegreen-deployment-group"
  outdated_instances_strategy = "UPDATE"
  service_role_arn            = var.ecs_codedeploy_group_service_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 60
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name
    service_name = aws_ecs_service.main.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.lb_listener_http_80_arn]
      }
      test_traffic_route {
        listener_arns = [var.lb_listener_http_10080_arn]
      }
      target_group {
        name = var.targetgroup_80_name
      }
      target_group {
        name = var.targetgroup_10080_name
      }
    }
  }

  tags = {
    Name = local.name
  }
}
