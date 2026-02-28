locals {
  database_url = "postgresql+psycopg2://${var.db_username}:${random_password.db.result}@${aws_db_instance.main.address}:5432/${var.db_name}"
  redis_url    = "redis://${aws_elasticache_replication_group.main.primary_endpoint_address}:6379/0"
}

resource "aws_secretsmanager_secret" "app" {
  name = "${local.name_prefix}/app"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id = aws_secretsmanager_secret.app.id
  secret_string = jsonencode({
    DATABASE_URL = local.database_url
    REDIS_URL    = local.redis_url
    QUEUE_NAME   = "job_queue"
  })
}
