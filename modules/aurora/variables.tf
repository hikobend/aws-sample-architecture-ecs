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

variable "env" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}
