resource "aws_vpc_endpoint_policy" "to_s3_policy" {
  vpc_endpoint_id = var.vpc_endpoint_to_s3_id
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

resource "aws_vpc_endpoint_policy" "to_ecr_api_policy" {
  vpc_endpoint_id = var.vpc_endpoint_to_ecr_api_id
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

resource "aws_vpc_endpoint_policy" "to_ecr_dkr_policy" {
  vpc_endpoint_id = var.vpc_endpoint_to_ecr_dkr_id
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
