resource "aws_security_group" "container" {
  description = "Security group for backend app"
  vpc_id      = var.vpc_id
  name        = "container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-container"
  }
}
