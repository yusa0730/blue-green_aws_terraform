resource "aws_rds_cluster_parameter_group" "this" {
  name   = "${local.name}-aurora-mysql8-pg"
  family = "aurora-mysql8.0"
  parameter {
    name         = "server_audit_logging"
    value        = "1"
    apply_method = "immediate"
  }
  parameter {
    name         = "server_audit_events"
    value        = "CONNECT,QUERY,TABLE"
    apply_method = "immediate"
  }
  parameter {
    name         = "server_audit_incl_users"
    value        = "user"
    apply_method = "immediate"
  }
  parameter {
    name         = "server_audit_excl_users"
    value        = "user"
    apply_method = "immediate"
  }
  tags = {
    name = "${local.name}-aurora-mysql8-pg"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier              = "${var.project_name}-${var.env}-cluster"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  db_subnet_group_name            = var.db_subnet_group_name
  availability_zones              = ["ap-northeast-1a", "ap-northeast-1c"]
  vpc_security_group_ids          = var.vpc_security_group_ids
  engine                          = "aurora-mysql"
  engine_version                  = var.engine_version
  engine_mode                     = var.engine_mode
  storage_type                    = null
  iops                            = var.iops
  network_type                    = "IPV4"
  port                            = 3306
  database_name                   = var.database_name
  master_username                 = var.master_username
  master_password                 = "password"

  storage_encrypted = true
  # kms_key_id                          = var.kms_key_id
  backup_retention_period             = var.backup_retention_period
  skip_final_snapshot                 = var.skip_final_snapshot
  final_snapshot_identifier           = "${var.project_name}-${var.env}-final-snapshot-rds-cluster"
  iam_database_authentication_enabled = true
  deletion_protection                 = var.deletion_protection
  apply_immediately                   = var.apply_immediately

  copy_tags_to_snapshot        = true
  backtrack_window             = 0
  preferred_maintenance_window = "sun:19:00-sun:19:30"

  # TODO：terada：負荷テスト用に一次的に追加（devのみでapply）
  snapshot_identifier = "arn:aws:rds:ap-northeast-1:447967512202:cluster-snapshot:porta-dev-cluster-202409241129"

  serverlessv2_scaling_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  tags = {
    name = "${var.project_name}-${var.env}-cluster"
  }
  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      master_password,
      availability_zones,
      global_cluster_identifier
    ]
  }
}

resource "aws_rds_cluster_instance" "main" {
  count = var.enable_cluster_instance ? local.cluster_instance_count : 0

  cluster_identifier           = aws_rds_cluster.main.id
  identifier                   = format("${var.project_name}-${var.env}-cluster-instance-%s", var.subnet_zone_id[count.index])
  engine                       = aws_rds_cluster.main.engine
  engine_version               = aws_rds_cluster.main.engine_version
  instance_class               = "db.serverless"
  db_subnet_group_name         = var.db_subnet_group_name
  availability_zone            = element(data.aws_availability_zones.current.names, count.index)
  publicly_accessible          = false
  auto_minor_version_upgrade   = false
  ca_cert_identifier           = "rds-ca-rsa2048-g1"
  performance_insights_enabled = var.performance_insights_enabled
  tags = {
    name = "${var.project_name}-${var.env}-cluster"
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/rds/cluster/${aws_rds_cluster.main.cluster_identifier}"
  retention_in_days = var.logs_retention_in_days
  tags = {
    Name = local.name
  }
}
