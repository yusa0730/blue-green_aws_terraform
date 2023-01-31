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
