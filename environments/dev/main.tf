locals {
  project_name = "ishizawa-terraform-test"
  env          = "dev"
  region       = "ap-northeast-1"
}

provider "aws" {
  region = local.region
}

module "vpc" {
  source = "../../modules/vpc"
  project_name = local.project_name
  env = local.env
}
