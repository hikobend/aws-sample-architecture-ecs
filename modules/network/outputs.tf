output "private_subnet_1a" {
  value       = module.network.private_subnets[0]
  description = "Private subnet 1a"
}

output "private_subnet_1c" {
  value       = module.network.private_subnets[1]
  description = "Private subnet 1c"
}
