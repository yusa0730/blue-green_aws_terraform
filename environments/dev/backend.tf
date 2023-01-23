terraform {
  backend "s3" {
    bucket = "blue-green-ecs-testbucket"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
