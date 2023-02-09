resource "aws_lb" "public" {
  name               = "${var.project_name}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  access_logs {
    bucket  = var.s3_alb_bucket
    prefix  = "alb"
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-${var.env}-alb"
  }
}

resource "aws_lb" "internal" {
  name               = "${var.project_name}-${var.env}-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.security_group_internal_ids
  subnets            = var.private_subnet_ids

  enable_deletion_protection = false

  access_logs {
    bucket  = var.s3_alb_bucket
    prefix  = "internal_alb"
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-${var.env}-internal-alb"
  }
}
