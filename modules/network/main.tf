################################################################################
# subnet
################################################################################
resource "aws_subnet" "public_alb" {
  count = length(var.alb_cidr_blocks)

  assign_ipv6_address_on_creation                = false
  cidr_block                                     = element(var.alb_cidr_blocks, count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = true
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = element(data.aws_availability_zones.current.names, count.index)

  tags = {
    Name = format("${var.project_name}-${var.env}-pub-alb-sbn-%s", var.subnet_zone_id[count.index])
  }

  vpc_id = var.vpc_id
}

resource "aws_subnet" "private_app" {
  count = length(var.app_cidr_blocks)

  assign_ipv6_address_on_creation                = false
  cidr_block                                     = element(var.app_cidr_blocks, count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = element(data.aws_availability_zones.current.names, count.index)

  tags = {
    Name = format("${var.project_name}-${var.env}-pri-app-sbn-%s", var.subnet_zone_id[count.index])
  }

  vpc_id = var.vpc_id
}

resource "aws_subnet" "private_aurora" {
  count = length(var.aurora_cidr_blocks)

  assign_ipv6_address_on_creation                = false
  cidr_block                                     = element(var.aurora_cidr_blocks, count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = element(data.aws_availability_zones.current.names, count.index)

  tags = {
    Name = format("${var.project_name}-${var.env}-pri-autora-sbn-%s", var.subnet_zone_id[count.index])
  }

  vpc_id = var.vpc_id
}

resource "aws_subnet" "private_endpoint" {
  count = length(var.endpoint_cidr_blocks)

  assign_ipv6_address_on_creation                = false
  cidr_block                                     = element(var.endpoint_cidr_blocks, count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = element(data.aws_availability_zones.current.names, count.index)

  tags = {
    Name = format("${var.project_name}-${var.env}-pri-vpce-sbn-%s", var.subnet_zone_id[count.index])
  }

  vpc_id = var.vpc_id
}

resource "aws_subnet" "private_bastion" {
  count = length(var.bastion_cidr_blocks)

  assign_ipv6_address_on_creation                = false
  cidr_block                                     = element(var.bastion_cidr_blocks, count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = element(data.aws_availability_zones.current.names, count.index)

  tags = {
    Name = format("${var.project_name}-${var.env}-pri-bastion-sbn-%s", var.subnet_zone_id[count.index])
  }

  vpc_id = var.vpc_id
}

################################################################################
# route_table
################################################################################
## public alb
resource "aws_route_table" "public_alb" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.env}-public-alb"
  }
}

resource "aws_route_table_association" "public_alb" {
  count = length(aws_subnet.public_alb)

  route_table_id = aws_route_table.public_alb.id
  subnet_id      = element(aws_subnet.public_alb[*].id, count.index)
}

## private app
resource "aws_route_table" "private_app" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.env}-private-app"
  }
}

resource "aws_route_table_association" "private_app" {
  count = length(aws_subnet.private_app)

  route_table_id = aws_route_table.private_app.id
  subnet_id      = element(aws_subnet.private_app[*].id, count.index)
}

## private aurora
resource "aws_route_table" "private_aurora" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.env}-private-aurora"
  }
}

resource "aws_route_table_association" "private_aurora" {
  count = length(aws_subnet.private_aurora)

  route_table_id = aws_route_table.private_aurora.id
  subnet_id      = element(aws_subnet.private_aurora[*].id, count.index)
}

## private vpce
resource "aws_route_table" "private_endpoint" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.env}-private-vpce"
  }
}

resource "aws_route_table_association" "private_endpoint" {
  count = length(aws_subnet.private_endpoint)

  route_table_id = aws_route_table.private_endpoint.id
  subnet_id      = element(aws_subnet.private_endpoint[*].id, count.index)
}

## private bastion
resource "aws_route_table" "private_bastion" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.env}-private-bastion"
  }
}

resource "aws_route_table_association" "private_bastion" {
  count = length(aws_subnet.private_bastion)

  route_table_id = aws_route_table.private_bastion.id
  subnet_id      = element(aws_subnet.private_bastion[*].id, count.index)
}

################################################################################
# gateway
################################################################################
resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.env}-igw"
  }
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public_alb.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

################################################################################
# gateway-endpoint
################################################################################
resource "aws_vpc_endpoint" "to_s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.private_app.id,
    aws_route_table.private_bastion.id,
  ]

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-s3"
  }
}

################################################################################
# interface-endpoint
################################################################################
resource "aws_vpc_endpoint" "to_ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = ["${var.vpce_sg_id}"]
  subnet_ids          = aws_subnet.private_endpoint[*].id

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-ecr-api"
  }
}

resource "aws_vpc_endpoint" "to_ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = ["${var.vpce_sg_id}"]
  subnet_ids          = aws_subnet.private_endpoint[*].id

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "to_logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = ["${var.vpce_sg_id}"]
  subnet_ids          = aws_subnet.private_endpoint[*].id
  private_dns_enabled = true

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-logs"
  }
}

resource "aws_vpc_endpoint" "to_secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = ["${var.vpce_sg_id}"]
  subnet_ids          = aws_subnet.private_endpoint[*].id
  private_dns_enabled = true

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-secretsmanager"
  }
}

resource "aws_vpc_endpoint" "to_ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = ["${var.vpce_sg_id}"]
  subnet_ids          = aws_subnet.private_endpoint[*].id
  private_dns_enabled = true

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-ssm"
  }
}

resource "aws_vpc_endpoint" "to_ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = ["${var.vpce_sg_id}"]
  subnet_ids          = aws_subnet.private_endpoint[*].id
  private_dns_enabled = true

  tags = {
    "Name" = "${var.project_name}-${var.env}-vpce-ssmmessages"
  }
}
