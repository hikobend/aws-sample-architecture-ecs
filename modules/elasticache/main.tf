resource "aws_cloudwatch_log_group" "slow_log" {
  name = "${var.env}-redis-cluster-slow-log"
}

resource "aws_cloudwatch_log_group" "engine_log" {
  name = "${var.env}-redis-cluster-engine-log"
}

resource "aws_iam_service_linked_role" "this" {
  aws_service_name = "elasticache.amazonaws.com"
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.env}-redis-subnet-group"
  subnet_ids = [var.private_subnet_1a, var.private_subnet_1c]
}

resource "aws_elasticache_cluster" "this" {
  cluster_id         = "${var.env}-redis-cluster"
  engine             = "redis"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  port               = 6379
  engine_version     = "6.2"
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
