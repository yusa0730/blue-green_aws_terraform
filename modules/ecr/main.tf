resource "aws_ecr_repository" "frontend" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
  name                 = "${var.project_name}-${var.env}-frontend"
}

resource "aws_ecr_lifecycle_policy" "frontend" {
  repository = aws_ecr_repository.frontend.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "古いイメージの削除",
        "selection": {
          "countNumber": 3,
          "countType": "imageCountMoreThan",
          "tagStatus": "any"
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}

resource "aws_ecr_repository" "backend" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
  name                 = "${var.project_name}-${var.env}-backend"
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.backend.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "古いイメージの削除",
        "selection": {
          "countNumber": 3,
          "countType": "imageCountMoreThan",
          "tagStatus": "any"
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}

resource "aws_ecr_repository" "bastion" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
  name                 = "${var.project_name}-${var.env}-bastion"
}

resource "aws_ecr_lifecycle_policy" "bastion" {
  repository = aws_ecr_repository.bastion.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "古いイメージの削除",
        "selection": {
          "countNumber": 3,
          "countType": "imageCountMoreThan",
          "tagStatus": "any"
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}
