resource "aws_security_group" "db" {
  description = "Security Group of database server"
  vpc_id      = var.vpc_id
  name        = "db"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "sbcntr-sg-db"
  }
}
