resource "aws_security_group" "management" {
  description = "Security Group of database server"
  vpc_id      = var.vpc_id
  name        = "management"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-management"
  }
}
