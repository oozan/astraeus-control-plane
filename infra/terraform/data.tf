resource "random_password" "db" {
  length           = 24
  special          = true
  override_special = "!#*()-_=+"
}

resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnets"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-subnets"
  })
}

resource "aws_db_instance" "main" {
  identifier             = "${replace(local.name_prefix, "_", "-")}-db"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.db.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  storage_encrypted      = true
  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db"
  })
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${local.name_prefix}-cache-subnets"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = replace("${local.name_prefix}-redis", "_", "-")
  description                = "Redis queue for ${local.name_prefix}"
  node_type                  = var.redis_node_type
  port                       = 6379
  parameter_group_name       = "default.redis7"
  num_cache_clusters         = 1
  engine                     = "redis"
  engine_version             = "7.1"
  automatic_failover_enabled = false
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = [aws_security_group.redis.id]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  tags = local.common_tags
}
