resource "aws_cloudwatch_log_group" "slow_log" {
  name              = "${var.env}-redis-cluster-slow-log"
  retention_in_days = var.log_group_retention_in_days
}

resource "aws_cloudwatch_log_group" "engine_log" {
  name              = "${var.env}-redis-cluster-engine-log"
  retention_in_days = var.log_group_retention_in_days
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.env}-redis-subnet-group"
  subnet_ids = [var.private_subnet_1a, var.private_subnet_1c]
}

resource "aws_elasticache_cluster" "this" {
  cluster_id         = "${var.env}-redis-cluster"
  engine             = "redis"
  node_type          = var.node_type
  num_cache_nodes    = var.num_cache_nodes
  port               = 6379
  engine_version     = var.engine_version
  apply_immediately  = true
  subnet_group_name  = aws_elasticache_subnet_group.this.name
  availability_zone  = var.availability_zone_1a
  security_group_ids = [var.redis_sg_id]
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.slow_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.engine_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "engine-log"
  }
}
