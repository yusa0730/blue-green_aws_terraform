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
