output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC id"
}

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

output "availability_zone_1a" {
  value       = module.network.azs[0]
  description = "Availability zone 1a"
}

output "frontend_sg" {
  value       = module.frontend_sg.security_group_id
  description = "Frontend security group id"
}

output "database_sg" {
  value       = module.database_sg.security_group_id
  description = "Database security group id"
}
