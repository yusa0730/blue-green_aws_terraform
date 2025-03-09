output "cluster_endpoint" {
  value = aws_rds_cluster.main.endpoint
}

output "cluster_identifier" {
  value = aws_rds_cluster.main.cluster_identifier
}

output "cluster_db_name" {
  value = aws_rds_cluster.main.database_name
}
