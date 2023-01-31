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
