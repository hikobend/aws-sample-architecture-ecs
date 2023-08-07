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

variable "env" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}
