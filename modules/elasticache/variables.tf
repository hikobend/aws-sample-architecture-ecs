variable "private_subnet_1a" {
  description = "Private subnet 1a"
  type        = string
}

variable "private_subnet_1c" {
  description = "Private subnet 1c"
  type        = string
}

variable "redis_sg_id" {
  description = "Redis security group id"
  type        = string
}

variable "availability_zone_1a" {
  description = "Availability zone 1a"
  type        = string
}

variable "retention_in_days" {
  description = "The number of days to retain log events"
  type        = number
  default     = 7
}

variable "node_type" {
  description = "The node type to use"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "The number of cache nodes to use"
  type        = number
  default     = 1
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "6.2"
}

variable "env" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}
