locals {
  project_name = "ishizawa-terraform-test"
  env          = "dev"
  region       = "ap-northeast-1"
}

module "vpc" {
  source       = "../../modules/vpc"
  project_name = local.project_name
  env          = local.env
}

output "vpc" {
  value = module.vpc
}

module "subnet" {
  source       = "../../modules/subnet"
  project_name = local.project_name
  env          = local.env
  region       = local.region
  vpc_id       = module.vpc.vpc_id
}

output "subnet" {
  value = module.subnet
}

module "route_table" {
  source                  = "../../modules/route_table"
  project_name            = local.project_name
  env                     = local.env
  vpc_id                  = module.vpc.vpc_id
  alb_private_subnet_a_id = module.subnet.alb_private_subnet_a_id
  alb_private_subnet_c_id = module.subnet.alb_private_subnet_c_id
  alb_private_subnet_d_id = module.subnet.alb_private_subnet_d_id
  ecs_private_subnet_a_id = module.subnet.ecs_private_subnet_a_id
  ecs_private_subnet_c_id = module.subnet.ecs_private_subnet_c_id
  ecs_private_subnet_d_id = module.subnet.ecs_private_subnet_d_id
}

output "route_table" {
  value = module.route_table
}

module "vpc_endpoint" {
  source                                  = "../../modules/vpc_endpoint"
  project_name                            = local.project_name
  env                                     = local.env
  region                                  = local.region
  vpc_id                                  = module.vpc.vpc_id
  private_table_id                        = module.route_table.private_table_id
  vpc_endpoint_to_ecr_private_subnet_a_id = module.subnet.vpc_endpoint_to_ecr_private_subnet_a_id
  vpc_endpoint_to_ecr_private_subnet_c_id = module.subnet.vpc_endpoint_to_ecr_private_subnet_c_id
}
