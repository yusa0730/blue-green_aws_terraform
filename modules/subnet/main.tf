## alb
resource "aws_subnet" "alb_private_subnet_a" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project_name}-alb-subnet-private-a"
  }
}

resource "aws_subnet" "alb_private_subnet_c" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.project_name}-alb-subnet-private-c"
  }
}

resource "aws_subnet" "alb_private_subnet_d" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "${var.region}d"

  tags = {
    Name = "${var.project_name}-alb-subnet-private-d"
  }
}

## ecs
resource "aws_subnet" "ecs_private_subnet_a" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.40.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project_name}-ecs-subnet-private-a"
  }
}

resource "aws_subnet" "ecs_private_subnet_c" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.50.0/24"
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.project_name}-ecs-subnet-private-c"
  }
}

resource "aws_subnet" "ecs_private_subnet_d" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.60.0/24"
  availability_zone = "${var.region}d"

  tags = {
    Name = "${var.project_name}-ecs-subnet-private-d"
  }
}

resource "aws_subnet" "vpc_endpoint_to_ecr_private_subnet_a" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.248.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project_name}-vpc-endpoint-to-ecr-subnet-private-a"
  }
}

resource "aws_subnet" "vpc_endpoint_to_ecr_private_subnet_c" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.249.0/24"
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.project_name}-vpc-endpoint-to-ecr-subnet-private-c"
  }
}
