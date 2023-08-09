locals {
  network = {
    cidr            = "10.0.0.0/24"
    azs             = ["ap-northeast-1a", "ap-northeast-1c"]
    public_subnets  = ["10.0.0.0/26", "10.0.0.64/26"]
    private_subnets = ["10.0.0.128/26", "10.0.0.192/26"]
  }
  aurora = {
    family                          = "aurora-mysql8.0"
    engine                          = "aurora-mysql"
    engine_version                  = "8.0.mysql_aurora.3.03.1"
    instance_class                  = "db.t3.medium"
    enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
    instances                       = ["first"]
  }
  elasticache = {
    retention_in_days = 7
    node_type         = "cache.t3.micro"
    num_cache_nodes   = 1
    engine_version    = "6.2"
  }
}
