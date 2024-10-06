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

# module "s3_bucket_of_alb_internal" {
#   source            = "../../modules/s3"
#   bucket_name       = "${local.project_name}-${local.env}-alb-internal"
#   versioning_status = "Enabled"
#   lifecycle_id      = "alb_internal_s3_bucket_log"
#   expiration_days   = 90
#   lifecycle_status  = "Enabled"
#   sse_algorithm     = "AES256"
# }

# module "s3_bucket_acl_of_alb_internal" {
#   source           = "../../modules/s3/bucket_acl"
#   s3_bucket_id     = module.s3_bucket_of_alb_internal.s3_bucket_id
#   grantee_type     = "CanonicalUser"
#   grant_permission = "READ_ACP"
# }

# module "s3_bucket_acl_of_alb_internal2" {
#   source           = "../../modules/s3/bucket_acl"
#   s3_bucket_id     = module.s3_bucket_of_alb_internal.s3_bucket_id
#   grantee_type     = "CanonicalUser"
#   grant_permission = "WRITE_ACP"
# }

# # module "public_alb" {
# #   source                            = "../../modules/alb"
# #   alb_name                          = "${local.project_name}-${local.env}-alb"
# #   security_group_ids                = []
# #   subnet_ids                        = []
# #   is_enabled_to_deletion_protection = false
# #   s3_alb_bucket                     = ""
# #   access_logs_prefix                = "alb"
# #   is_enabled_to_access_logs         = true
# # }

# module "internal_alb" {
#   source      = "../../modules/alb"
#   alb_name    = "${local.project_name}-${local.env}-internal-alb"
#   is_internal = true
#   security_group_ids = [
#     module.security_group_alb.sg_alb_internal_id
#   ]
#   subnet_ids = [
#     module.alb_private_subnet_a.subnet_id,
#     module.alb_private_subnet_c.subnet_id,
#     module.alb_private_subnet_d.subnet_id
#   ]
#   s3_alb_bucket      = module.s3_bucket_of_alb_internal.s3_bucket_id
#   access_logs_prefix = "internal_alb"
# }

# module "internal_alb_target_group_blue" {
#   source            = "../../modules/alb/target_group"
#   target_group_name = "${local.project_name}-${local.env}-alb-blue-tg"
#   vpc_id            = module.vpc.vpc_id
# }

# module "internal_alb_target_group_green" {
#   source            = "../../modules/alb/target_group"
#   target_group_name = "${local.project_name}-${local.env}-alb-green-tg"
#   target_group_port = 10080
#   vpc_id            = module.vpc.vpc_id
# }

# module "internal_alb_listener_blue" {
#   source            = "../../modules/alb/listener"
#   load_balancer_arn = module.internal_alb.alb_arn
#   target_group_arn  = module.internal_alb_target_group_blue.target_group_arn
# }

# module "internal_alb_listener_green" {
#   source            = "../../modules/alb/listener"
#   load_balancer_arn = module.internal_alb.alb_arn
#   port_number       = 10080
#   target_group_arn  = module.internal_alb_target_group_green.target_group_arn
# }
