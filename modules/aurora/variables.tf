variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "private_subnet_1a" {
  description = "The private subnet in AZ 1a"
  type        = string
}

variable "private_subnet_1c" {
  description = "The private subnet in AZ 1c"
  type        = string
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster"
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "8.0.mysql_aurora.3.03.1"
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.t3.medium"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = ["audit", "error", "slowquery"]
}

variable "instances" {
  description = "The instances to create"
  type        = list(string)
}

variable "env" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}
