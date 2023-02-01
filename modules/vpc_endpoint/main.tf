resource "aws_vpc_endpoint" "to_s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_table_id]

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-s3"
  }
}
resource "aws_vpc_endpoint" "to_ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = ["${var.sg_vpc_endpoint_id}"]
  subnet_ids          = var.vpc_endpoint_to_ecr_subnet_ids

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-ecr-api"
  }
}

resource "aws_vpc_endpoint" "to_ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = ["${var.sg_vpc_endpoint_id}"]
  subnet_ids          = var.vpc_endpoint_to_ecr_subnet_ids

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-ecr-dkr"
  }
}
