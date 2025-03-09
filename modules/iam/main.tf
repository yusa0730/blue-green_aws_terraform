// =======ecs task execution=======
resource "aws_iam_role" "ecs_task_execution_iar" {
  name               = "${var.project_name}-${var.env}-ecs-task-execution-iar"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_iar.json

  tags = {
    Name      = "${var.project_name}-${var.env}-ecs-task-execution-iar"
    Env       = var.env
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_policy" "ecs_task_execution_iap" {
  name   = "${var.project_name}-${var.env}-ecs-task-execution-iap"
  policy = data.aws_iam_policy_document.ecs_task_execution_iap.json

  tags = {
    Name      = "${var.project_name}-${var.env}-ecs-task-execution-iap"
    Env       = var.env
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_iar_AmazonECSTaskExecutionRolePolicy" {
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
  role       = aws_iam_role.ecs_task_execution_iar.name
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_iar_ecs_task_execution_iap" {
  policy_arn = aws_iam_policy.ecs_task_execution_iap.arn
  role       = aws_iam_role.ecs_task_execution_iar.name
}

// =======ecs task=======
resource "aws_iam_role" "bastion_ecs_task_iar" {
  name               = "${var.project_name}-${var.env}-bastion-ecs-task-iar"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_iar.json

  tags = {
    Name      = "${var.project_name}-${var.env}-bastion-ecs-task-iar"
    Env       = var.env
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_policy" "ecs_task_iap" {
  name   = "${var.project_name}-${var.env}-ecs-task-iap"
  policy = data.aws_iam_policy_document.ecs_task_iap.json

  tags = {
    Name      = "${var.project_name}-${var.env}-ecs-task-iap"
    Env       = var.env
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_policy" "ssm_passrole_iap" {
  name   = "${var.project_name}-${var.env}-ssm-passrole-iap"
  policy = data.aws_iam_policy_document.ssm_passrole_iap.json

  tags = {
    Name      = "${var.project_name}-${var.env}-ssm-passrole-iap"
    Env       = var.env
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "bastion_ecs_task_iar_ecs_task_iap" {
  policy_arn = aws_iam_policy.ecs_task_iap.arn
  role       = aws_iam_role.bastion_ecs_task_iar.name
}

resource "aws_iam_role_policy_attachment" "bastion_ecs_task_iar_ssm_passrole_iap" {
  policy_arn = aws_iam_policy.ssm_passrole_iap.arn
  role       = aws_iam_role.bastion_ecs_task_iar.name
}

// =======ssm service=======
resource "aws_iam_role" "ssm_service_iar" {
  name               = "${var.project_name}-${var.env}-ssm-service-iar"
  assume_role_policy = data.aws_iam_policy_document.ssm_service_iar.json

  tags = {
    Name      = "${var.project_name}-${var.env}-ssm-service-iar"
    Env       = var.env
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_service_iar_AmazonSSMManagedInstanceCore" {
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  role       = aws_iam_role.ssm_service_iar.name
}

// =======code deploy=======
resource "aws_iam_role" "ecs_code_deploy_iar" {
  name               = "${var.project_name}-${var.env}-ecs-code-deploy-iar"
  assume_role_policy = data.aws_iam_policy_document.ecs_code_deploy_iar.json

  tags = {
    Name      = "${var.project_name}-${var.env}-ecs-code-deploy-iar"
    Env       = var.env
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_code_deploy_iar_AWSCodeDeployRoleForECS" {
  policy_arn = data.aws_iam_policy.AWSCodeDeployRoleForECS.arn
  role       = aws_iam_role.ecs_code_deploy_iar.name
}
