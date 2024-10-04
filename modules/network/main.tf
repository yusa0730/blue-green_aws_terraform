resource "aws_vpc" "main" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = var.vpc_cidr_block
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  tags = {
    Name = "${var.project_name}-${var.env}-vpc"
  }
  tags_all = {
    Name = "${var.project_name}-${var.env}-vpc"
  }
}

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
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = element(data.aws_availability_zones.current.names, count.index)

  tags = {
    Name = format("${var.project_name}-alb-${var.env}-pub-%s-sbn", var.subnet_zone_id[count.index])
  }

  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private_container" {
  count = length(var.container_cidr_blocks)

  assign_ipv6_address_on_creation                = false
  cidr_block                                     = element(var.container_cidr_blocks, count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = element(data.aws_availability_zones.current.names, count.index)

  tags = {
    Name = format("${var.project_name}-container-${var.env}-pri-%s-sbn", var.subnet_zone_id[count.index])
  }

  vpc_id = aws_vpc.main.id
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
    Name = format("porta-aurora-${var.env}-pri-%s-sbn", var.subnet_zone_id[count.index])
  }

  vpc_id = aws_vpc.main.id
}

################################################################################
# route_table
################################################################################



################################################################################
# gateway
################################################################################



################################################################################
# gateway-endpoint
################################################################################




################################################################################
# interface-endpoint
################################################################################
