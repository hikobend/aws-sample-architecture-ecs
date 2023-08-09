output "cluster_security_group_id" {
  value       = module.cluster.security_group_id
  description = "Aurora security group id"
}
