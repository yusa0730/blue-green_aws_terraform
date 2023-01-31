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

module "alb_private_subnet_a" {
  source     = "../../modules/vpc/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.10.0/24"
  az         = "${local.region}a"
  name       = "${local.project_name}-${local.env}-alb-subnet-private-a"
}

module "alb_private_subnet_c" {
  source     = "../../modules/vpc/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.20.0/24"
  az         = "${local.region}c"
  name       = "${local.project_name}-${local.env}-alb-subnet-private-c"
}

module "alb_private_subnet_d" {
  source     = "../../modules/vpc/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.30.0/24"
  az         = "${local.region}d"
  name       = "${local.project_name}-${local.env}-alb-subnet-private-d"
}

module "ecs_private_subnet_a" {
  source     = "../../modules/vpc/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.40.0/24"
  az         = "${local.region}a"
  name       = "${local.project_name}-${local.env}-ecs-subnet-private-a"
}

module "ecs_private_subnet_c" {
  source     = "../../modules/vpc/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.50.0/24"
  az         = "${local.region}c"
  name       = "${local.project_name}-${local.env}-ecs-subnet-private-c"
}

module "ecs_private_subnet_d" {
  source     = "../../modules/vpc/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.60.0/24"
  az         = "${local.region}d"
  name       = "${local.project_name}-${local.env}-ecs-subnet-private-d"
}

module "vpc_endpoint_to_ecr_private_subnet_a" {
  source     = "../../modules/vpc/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.248.0/24"
  az         = "${local.region}a"
  name       = "${local.project_name}-${local.env}-vpc-endpoint-to-ecr-subnet-private-a"
}

module "vpc_endpoint_to_ecr_private_subnet_c" {
  source     = "../../modules/vpc/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.249.0/24"
  az         = "${local.region}c"
  name       = "${local.project_name}-${local.env}-vpc-endpoint-to-ecr-subnet-private-c"
}

module "route_table" {
  source                  = "../../modules/vpc/route_table"
  project_name            = local.project_name
  env                     = local.env
  vpc_id                  = module.vpc.vpc_id
  alb_private_subnet_a_id = module.alb_private_subnet_a.subnet_id
  alb_private_subnet_c_id = module.alb_private_subnet_c.subnet_id
  alb_private_subnet_d_id = module.alb_private_subnet_d.subnet_id
  ecs_private_subnet_a_id = module.ecs_private_subnet_a.subnet_id
  ecs_private_subnet_c_id = module.ecs_private_subnet_c.subnet_id
  ecs_private_subnet_d_id = module.ecs_private_subnet_d.subnet_id
}

module "security_group_alb" {
  source = "../../modules/security_group/alb"
  vpc_id = module.vpc.vpc_id
}

module "security_group_container" {
  source = "../../modules/security_group/container"
  vpc_id = module.vpc.vpc_id
}

module "security_group_db" {
  source = "../../modules/security_group/db"
  vpc_id = module.vpc.vpc_id
}

module "security_group_front_container" {
  source = "../../modules/security_group/front_container"
  vpc_id = module.vpc.vpc_id
}

module "security_group_ingress" {
  source = "../../modules/security_group/ingress"
  vpc_id = module.vpc.vpc_id
}

module "security_group_management" {
  source = "../../modules/security_group/management"
  vpc_id = module.vpc.vpc_id
}

module "security_group_vpc_endpoint" {
  source = "../../modules/security_group/vpc_endpoint"
  vpc_id = module.vpc.vpc_id
}

module "security_group_rule" {
  source                = "../../modules/security_group_rule"
  sg_ingress_id         = module.security_group_ingress.sg_ingress_id
  sg_alb_internal_id    = module.security_group_alb.sg_alb_internal_id
  sg_container_id       = module.security_group_container.sg_container_id
  sg_db_id              = module.security_group_db.sg_db_id
  sg_front_container_id = module.security_group_front_container.sg_front_container_id
  sg_management_id      = module.security_group_management.sg_management_id
  sg_vpc_endpoint_id    = module.security_group_vpc_endpoint.sg_vpc_endpoint_id
}

module "vpc_endpoint" {
  source                                  = "../../modules/vpc_endpoint"
  project_name                            = local.project_name
  env                                     = local.env
  region                                  = local.region
  vpc_id                                  = module.vpc.vpc_id
  private_table_id                        = module.route_table.private_table_id
  vpc_endpoint_to_ecr_private_subnet_a_id = module.vpc_endpoint_to_ecr_private_subnet_a.subnet_id
  vpc_endpoint_to_ecr_private_subnet_c_id = module.vpc_endpoint_to_ecr_private_subnet_c.subnet_id
  sg_vpc_endpoint_id                      = module.security_group_vpc_endpoint.sg_vpc_endpoint_id
}

module "vpc_endpoint_policy" {
  source                     = "../../modules/vpc_endpoint/policy"
  vpc_endpoint_to_s3_id      = module.vpc_endpoint.vpc_endpoint_to_s3_id
  vpc_endpoint_to_ecr_api_id = module.vpc_endpoint.vpc_endpoint_to_ecr_api_id
  vpc_endpoint_to_ecr_dkr_id = module.vpc_endpoint.vpc_endpoint_to_ecr_dkr_id
}
