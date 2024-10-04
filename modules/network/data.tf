data "aws_availability_zones" "current" {
  filter {
    name   = "zone-name"
    values = ["*a", "*c", "*d"]
  }
}
