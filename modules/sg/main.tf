## public alb
resource "aws_security_group" "public_alb" {
  description = "Security Group of ingress"
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-${var.env}-sg-public-alb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.env}-sg-public-alb"
  }
}

## front container
resource "aws_security_group" "front_container" {
  description = "Security group for front container app"
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-${var.env}-sg-front-container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.env}-sg-front-container"
  }
}

resource "aws_security_group_rule" "front_container_from_sg_public_alb_HTTP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.front_container.id
  source_security_group_id = aws_security_group.public_alb.id
}

## internal alb
resource "aws_security_group" "internal_alb" {
  description = "Security group for internal load balancer"
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-${var.env}-sg-internal-alb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.env}-sg-internal-alb"
  }
}

resource "aws_security_group_rule" "internal_alb_from_sg_management_HTTP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.internal_alb.id
  source_security_group_id = aws_security_group.management.id
}

resource "aws_security_group_rule" "internal_alb_from_sg_management_10080" {
  type                     = "ingress"
  from_port                = 10080
  to_port                  = 10080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.internal_alb.id
  source_security_group_id = aws_security_group.management.id
}

resource "aws_security_group_rule" "internal_alb_from_sg_front_container_HTTP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.internal_alb.id
  source_security_group_id = aws_security_group.front_container.id
}

## container
resource "aws_security_group" "container" {
  description = "Security group for backend app"
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-${var.env}-sg-app-container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.env}-sg-app-container"
  }
}

resource "aws_security_group_rule" "container_from_sg_alb_internal_HTTP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.container.id
  source_security_group_id = aws_security_group.internal_alb.id
}

## db
resource "aws_security_group" "db" {
  description = "Security Group of database server"
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-${var.env}-sg-db"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.env}-sg-db"
  }
}

resource "aws_security_group_rule" "db_from_sg_front_container" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.front_container.id
}

resource "aws_security_group_rule" "db_from_sg_container" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.container.id
}

resource "aws_security_group_rule" "db_from_sg_management" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.management.id
}

## management bastion
resource "aws_security_group" "management" {
  description = "Security Group of management bastion server"
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-${var.env}-sg-management"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.env}-sg-management"
  }
}

## vpc_endpoint
resource "aws_security_group" "vpce" {
  description = "Security Group of VPC Endpoint"
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-${var.env}-sg-vpce"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.project_name}-${var.env}-sg-vpce"
  }
}

resource "aws_security_group_rule" "vpc_endpoint_from_sg_container_HTTPS" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpce.id
  source_security_group_id = aws_security_group.container.id
}

resource "aws_security_group_rule" "vpc_endpoint_from_sg_front_container_HTTPS" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpce.id
  source_security_group_id = aws_security_group.front_container.id
}

resource "aws_security_group_rule" "vpc_endpoint_from_sg_management_HTTPS" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpce.id
  source_security_group_id = aws_security_group.management.id
}
