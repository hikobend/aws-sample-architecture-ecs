output "private_subnet_1a" {
  value       = module.network.private_subnets[0]
  description = "Private subnet 1a"
}

output "private_subnet_1c" {
  value       = module.network.private_subnets[1]
  description = "Private subnet 1c"
}

output "redis_sg_id" {
  value       = module.elasticache_sg.security_group_id
  description = "Redis security group id"
}
