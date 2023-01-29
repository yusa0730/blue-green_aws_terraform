resource "aws_vpc_endpoint" "to_s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_table_id]

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-s3"
  }
}

resource "aws_vpc_endpoint_policy" "to_s3_policy" {
  vpc_endpoint_id = aws_vpc_endpoint.to_s3.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_vpc_endpoint" "to_ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = ["${var.sg_vpc_endpoint_id}"]
  subnet_ids = [
    var.vpc_endpoint_to_ecr_private_subnet_a_id,
    var.vpc_endpoint_to_ecr_private_subnet_c_id
  ]

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-ecr-api"
  }
}

resource "aws_vpc_endpoint_policy" "to_ecr_api_policy" {
  vpc_endpoint_id = aws_vpc_endpoint.to_ecr_api.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_vpc_endpoint" "to_ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = ["${var.sg_vpc_endpoint_id}"]
  subnet_ids = [
    var.vpc_endpoint_to_ecr_private_subnet_a_id,
    var.vpc_endpoint_to_ecr_private_subnet_c_id
  ]

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-ecr-dkr"
  }
}

resource "aws_vpc_endpoint_policy" "to_ecr_dkr_policy" {
  vpc_endpoint_id = aws_vpc_endpoint.to_ecr_dkr.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}
