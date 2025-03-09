data "aws_caller_identity" "current" {}

################################################################################
data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "AWSCodeDeployRoleForECS" {
  arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# data "aws_iam_policy" "AllowECRPullThroughCacheImage" {
#   arn = "arn:aws:iam::${data.aws_caller_identity.current.id}:policy/AllowECRPullThroughCacheImage"
# }
# ################################################################################
data "aws_iam_policy_document" "ecs_task_execution_iar" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_iap" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.current.id}:repository:${var.project_name}-${var.env}-backend",
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.current.id}:repository:${var.project_name}-${var.env}-frontend",
      "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.current.id}:repository:${var.project_name}-${var.env}-bastion"
    ]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_task_iar" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_iap" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*"
    ]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ssm_passrole_iap" {
  statement {
    actions = [
      "iam:PassRole"
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ssm.amazonaws.com"]
    }
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "ssm:CreateActivation",
      "ssm:DeleteActivation",
      "ssm:AddTagsToResource",
      "ssm:RemoveTagsFromResource",
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ssm_service_iar" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_code_deploy_iar" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}
