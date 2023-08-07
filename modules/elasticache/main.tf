resource "aws_elasticache_cluster" "this" {
  cluster_id      = "${var.env}-redis-cluster"
  engine          = "redis"
  node_type       = "cache.t3.micro"
  num_cache_nodes = 1
  port            = 6379
  engine_version  = "6.2"
}
