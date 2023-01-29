resource "aws_security_group" "ingress" {
  description = "Security Group of ingress"
  vpc_id      = var.vpc_id
  name        = "ingress"

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
    "Name" = "sbcntr-sg-ingress"
  }
}

resource "aws_security_group" "management" {
  description = "Security Group of database server"
  vpc_id      = var.vpc_id
  name        = "management"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-management"
  }
}

resource "aws_security_group" "container" {
  description = "Security group for backend app"
  vpc_id      = var.vpc_id
  name        = "container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-container"
  }
}

resource "aws_security_group" "front_container" {
  description = "Security group for front container app"
  vpc_id      = var.vpc_id
  name        = "front_container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-front-container"
  }
}

resource "aws_security_group" "alb_internal" {
  description = "Security group for internal load balancer"
  vpc_id      = var.vpc_id
  name        = "alb_internal"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-internal"
  }
}

resource "aws_security_group" "db" {
  description = "Security Group of database server"
  vpc_id      = var.vpc_id
  name        = "db"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-db"
  }
}

resource "aws_security_group" "vpc_endpoint" {
  description = "Security Group of VPC Endpoint"
  vpc_id      = var.vpc_id
  name        = "vpc_endpoint"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-vpce"
  }
}

## ingress rule of container
resource "aws_security_group_rule" "sg_container_from_sg_internal" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.container.id
  source_security_group_id = aws_security_group.alb_internal.id
}

## ingress rule of front container
resource "aws_security_group_rule" "sg_front_container_from_sg_ingress_TCP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.front_container.id
  source_security_group_id = aws_security_group.ingress.id
}

## ingress rule of alb_internal
resource "aws_security_group_rule" "alb_internal_from_sg_management_TCP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_internal.id
  source_security_group_id = aws_security_group.management.id
}

resource "aws_security_group_rule" "alb_internal_from_sg_front_container_TCP" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_internal.id
  source_security_group_id = aws_security_group.front_container.id
}

## ingress rule of db
resource "aws_security_group_rule" "db_from_sg_container_TCP" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.container.id
}

resource "aws_security_group_rule" "db_from_sg_front_container_TCP" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.front_container.id
}

resource "aws_security_group_rule" "db_from_sg_management_TCP" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.management.id
}

## ingress rule of vpc_endpoint
resource "aws_security_group_rule" "vpc_endpoint_from_sg_container_TCP" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpc_endpoint.id
  source_security_group_id = aws_security_group.container.id
}

resource "aws_security_group_rule" "vpc_endpoint_from_sg_front_container_TCP" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpc_endpoint.id
  source_security_group_id = aws_security_group.front_container.id
}

resource "aws_security_group_rule" "vpc_endpoint_from_sg_management_TCP" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpc_endpoint.id
  source_security_group_id = aws_security_group.management.id
}
