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
