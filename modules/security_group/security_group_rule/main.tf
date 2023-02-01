## alb
resource "aws_security_group_rule" "alb_internal_from_sg_management_HTTP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = var.sg_alb_internal_id
  source_security_group_id = var.sg_management_id
}

resource "aws_security_group_rule" "alb_internal_from_sg_front_container_HTTP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = var.sg_alb_internal_id
  source_security_group_id = var.sg_front_container_id
}

## container
resource "aws_security_group_rule" "container_from_sg_alb_internal_HTTP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = var.sg_container_id
  source_security_group_id = var.sg_alb_internal_id
}

## db
resource "aws_security_group_rule" "db_from_sg_container_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.sg_db_id
  source_security_group_id = var.sg_container_id
}

resource "aws_security_group_rule" "db_from_sg_front_container_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.sg_db_id
  source_security_group_id = var.sg_front_container_id
}


resource "aws_security_group_rule" "db_from_sg_management_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.sg_db_id
  source_security_group_id = var.sg_management_id
}

## front_container
resource "aws_security_group_rule" "front_container_from_sg_ingress_HTTP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = var.sg_front_container_id
  source_security_group_id = var.sg_ingress_id
}

## vpc_endpoint
resource "aws_security_group_rule" "vpc_endpoint_from_sg_container_HTTPS" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = var.sg_vpc_endpoint_id
  source_security_group_id = var.sg_container_id
}

resource "aws_security_group_rule" "vpc_endpoint_from_sg_front_container_HTTPS" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = var.sg_vpc_endpoint_id
  source_security_group_id = var.sg_front_container_id
}

resource "aws_security_group_rule" "vpc_endpoint_from_sg_management_HTTPS" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = var.sg_vpc_endpoint_id
  source_security_group_id = var.sg_management_id
}
