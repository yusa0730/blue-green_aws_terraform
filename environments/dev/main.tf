locals {
  project_name = "ishizawa-terraform-test"
  env          = "dev"
  region       = "ap-northeast-1"
}

provider "aws" {
  region = local.region
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
  vpc_id       = module.vpc.vpc_id
  project_name = local.project_name
  env          = local.env
  region       = local.region
}

output "subnet" {
  value = module.subnet
}

module "route_table" {
  source                  = "../../modules/route_table"
  vpc_id                  = module.vpc.vpc_id
  project_name            = local.project_name
  env                     = local.env
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
