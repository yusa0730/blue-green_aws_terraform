provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "blue-green-ecs-testbucket"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

