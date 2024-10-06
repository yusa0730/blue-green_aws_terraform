data "aws_availability_zones" "current" {
  filter {
    name   = "zone-name"
    values = ["*a", "*c", "*d"]
  }
}

data "aws_vpc_endpoint_service" "s3" {
  service      = "s3"
  service_type = "Gateway"
}

data "aws_vpc_endpoint_service" "ecr_dkr" {
  service      = "ecr.dkr"
  service_type = "Interface"
}

data "aws_vpc_endpoint_service" "ecr_api" {
  service      = "ecr.api"
  service_type = "Interface"
}

data "aws_vpc_endpoint_service" "logs" {
  service      = "logs"
  service_type = "Interface"
}
