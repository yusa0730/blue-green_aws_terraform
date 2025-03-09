module "vpc" {
  source         = "../../modules/vpc"
  project_name   = var.project_name
  env            = var.env
  vpc_cidr_block = var.vpc_cidr_block
}

module "sg" {
  source       = "../../modules/sg"
  project_name = var.project_name
  env          = var.env
  vpc_id       = module.vpc.vpc_id
}

module "network" {
  source = "../../modules/network"

  alb_cidr_blocks      = var.alb_cidr_blocks
  app_cidr_blocks      = var.app_cidr_blocks
  aurora_cidr_blocks   = var.aurora_cidr_blocks
  project_name         = var.project_name
  env                  = var.env
  vpc_id               = module.vpc.vpc_id
  endpoint_cidr_blocks = var.endpoint_cidr_blocks
  region               = var.aws_default_region
  vpce_sg_id           = module.sg.vpce_sg_id
  bastion_cidr_blocks  = var.bastion_cidr_blocks
}

module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
  env          = var.env
}

module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  env          = var.env
}

module "bastion" {
  source                    = "../../modules/bastion"
  project_name              = var.project_name
  env                       = var.env
  logs_retention_in_days    = 30
  enable_container_insights = "enabled"
  desired_count             = 1
  ecs_subnet_ids            = module.network.bastion_subnet_ids
  ecs_sg_ids                = [module.sg.management_sg_id]
  image                     = var.ecr_bastion_image
  name_suffix               = "bastion"
  execution_role_arn        = module.iam.ecs_task_execution_iar_arn
  task_role_arn             = module.iam.bastion_ecs_task_iar_arn
}

module "s3" {
  source            = "../../modules/s3"
  bucket_name       = "${var.project_name}-${var.env}-alb-access-logs"
  versioning_status = "Enabled"
  lifecycle_id      = "alb_access_logs"
  expiration_days   = 90
  lifecycle_status  = "Enabled"
  sse_algorithm     = "AES256"
  is_destroyed      = true
}

## =======public alb=========
module "public_alb" {
  source             = "../../modules/alb"
  alb_name           = "${var.project_name}-${var.env}-public-alb"
  is_internal        = false
  security_group_ids = [module.sg.public_alb_sg_id]
  subnet_ids         = module.network.public_alb_subnet_ids
  s3_alb_bucket      = module.s3.alb_s3_bucket_id
  access_logs_prefix = "public-alb"
  load_balancer_type = "application"
}

module "public_alb_target_group_80" {
  source                                 = "../../modules/alb/target_group"
  target_group_name                      = "${var.project_name}-${var.env}-public-alb-tg"
  target_group_port                      = 80
  target_group_protocol                  = "HTTP"
  target_group_protocol_version          = "HTTP1"
  target_group_target_type               = "ip"
  is_enabled_to_health_check             = true
  vpc_id                                 = module.vpc.vpc_id
  healthy_threshold_count                = 3
  health_check_interval                  = "15"
  health_check_matcher                   = "200"
  health_check_path                      = "/healthcheck"
  health_check_port                      = "traffic-port"
  health_check_protocol                  = "HTTP"
  health_check_timeout                   = "5"
  health_check_unhealthy_threshold_count = "2"
  load_balancing_algorithm_type          = "round_robin"
}

module "public_alb_listener" {
  source            = "../../modules/alb/listener"
  load_balancer_arn = module.public_alb.arn
  port_number       = 80
  protocol          = "HTTP"
  action_type       = "forward"
  target_group_arn  = module.public_alb_target_group_80.target_group_arn
  action_order      = "10"
}

## =======frontend ecs=========
module "frontend_ecs" {
  source                    = "../../modules/ecs/frontend"
  logs_retention_in_days    = 30
  enable_container_insights = "enabled"
  lb_listener_http_80_arn   = module.public_alb_listener.listener_arn
  targetgroup_80_arn        = module.public_alb_target_group_80.target_group_arn
  targetgroup_80_name       = module.public_alb_target_group_80.target_group_name
  ecr_repository_url        = module.ecr.frontend_ecr_repository_url
  name_suffix               = "frontend"
  region                    = var.aws_default_region
  desired_count             = 1
  env                       = var.env
  project_name              = var.project_name
  vpc_id                    = module.vpc.vpc_id
  ecs_subnet_ids            = module.network.private_app_subnet_ids
  execution_role_arn        = module.iam.ecs_task_execution_iar_arn
  task_role_arn             = module.iam.bastion_ecs_task_iar_arn
  ecs_sg_ids                = [module.sg.front_container_sg_id]
  alb_dns_name              = module.internal_alb.dns_name
}

## =======internal alb=========
module "internal_alb" {
  source      = "../../modules/alb"
  alb_name    = "${var.project_name}-${var.env}-internal-alb"
  is_internal = true
  security_group_ids = [
    module.sg.internal_alb_sg_id
  ]
  subnet_ids         = module.network.private_app_subnet_ids
  s3_alb_bucket      = module.s3.alb_s3_bucket_id
  access_logs_prefix = "internal-alb"
  load_balancer_type = "application"
}

module "internal_alb_target_group_blue_80" {
  source                                 = "../../modules/alb/target_group"
  target_group_name                      = "${var.project_name}-${var.env}-alb-blue-tg"
  target_group_port                      = 80
  target_group_protocol                  = "HTTP"
  target_group_protocol_version          = "HTTP1"
  target_group_target_type               = "ip"
  is_enabled_to_health_check             = true
  vpc_id                                 = module.vpc.vpc_id
  healthy_threshold_count                = 3
  health_check_interval                  = "15"
  health_check_matcher                   = "200"
  health_check_path                      = "/healthcheck"
  health_check_port                      = "traffic-port"
  health_check_protocol                  = "HTTP"
  health_check_timeout                   = "5"
  health_check_unhealthy_threshold_count = "2"
  load_balancing_algorithm_type          = "round_robin"
}

module "internal_alb_target_group_green_10080" {
  source                                 = "../../modules/alb/target_group"
  target_group_name                      = "${var.project_name}-${var.env}-alb-green-tg"
  target_group_port                      = 10080
  target_group_protocol                  = "HTTP"
  target_group_protocol_version          = "HTTP1"
  target_group_target_type               = "ip"
  is_enabled_to_health_check             = true
  vpc_id                                 = module.vpc.vpc_id
  healthy_threshold_count                = 3
  health_check_interval                  = "15"
  health_check_matcher                   = "200"
  health_check_path                      = "/healthcheck"
  health_check_port                      = "traffic-port"
  health_check_protocol                  = "HTTP"
  health_check_timeout                   = "5"
  health_check_unhealthy_threshold_count = "2"
  load_balancing_algorithm_type          = "round_robin"
}

module "internal_alb_listener_blue" {
  source            = "../../modules/alb/listener"
  load_balancer_arn = module.internal_alb.arn
  port_number       = 80
  protocol          = "HTTP"
  action_type       = "forward"
  target_group_arn  = module.internal_alb_target_group_blue_80.target_group_arn
  action_order      = "10"
}

module "internal_alb_listener_green" {
  source            = "../../modules/alb/listener"
  load_balancer_arn = module.internal_alb.arn
  port_number       = 10080
  protocol          = "HTTP"
  action_type       = "forward"
  target_group_arn  = module.internal_alb_target_group_green_10080.target_group_arn
  action_order      = "1"
}

## =======backend ecs=========
module "backend_ecs" {
  source                           = "../../modules/ecs/backend"
  logs_retention_in_days           = 30
  enable_container_insights        = "enabled"
  lb_listener_http_80_arn          = module.internal_alb_listener_blue.listener_arn
  targetgroup_80_arn               = module.internal_alb_target_group_blue_80.target_group_arn
  targetgroup_80_name              = module.internal_alb_target_group_blue_80.target_group_name
  lb_listener_http_10080_arn       = module.internal_alb_listener_green.listener_arn
  targetgroup_10080_name           = module.internal_alb_target_group_green_10080.target_group_name
  ecr_repository_url               = module.ecr.backend_ecr_repository_url
  name_suffix                      = "backend"
  region                           = var.aws_default_region
  desired_count                    = 2
  env                              = var.env
  project_name                     = var.project_name
  vpc_id                           = module.vpc.vpc_id
  ecs_subnet_ids                   = module.network.private_app_subnet_ids
  execution_role_arn               = module.iam.ecs_task_execution_iar_arn
  task_role_arn                    = module.iam.bastion_ecs_task_iar_arn
  ecs_codedeploy_group_service_arn = module.iam.ecs_code_deploy_iar_arn
  ecs_sg_ids                       = [module.sg.container_sg_id]
}
