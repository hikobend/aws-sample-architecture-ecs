resource "aws_elasticache_cluster" "this" {
  cluster_id         = "${var.env}-redis-cluster"
  engine             = "redis"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  port               = 6379
  engine_version     = "6.2"
  apply_immediately  = false
  subnet_group_name  = aws_elasticache_subnet_group.this.name
  availability_zone  = var.availability_zone_1a
  security_group_ids = [var.redis_sg_id]
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.env}-redis-subnet-group"
  subnet_ids = [var.private_subnet_1a, var.private_subnet_1c]
}
