variable "alb_sg" {
  description = "ALB security group id"
  type        = string
}

# variable "frontend_sg" {
#   description = "Frontend security group id"
#   type        = string
# }

variable "public_subnet_1a" {
  description = "Public subnet id in availability zone 1a"
  type        = string
}

variable "public_subnet_1c" {
  description = "Public subnet id in availability zone 1c"
  type        = string
}

variable "private_subnet_1a" {
  description = "Private subnet id in availability zone 1a"
  type        = string
}

variable "private_subnet_1c" {
  description = "Private subnet id in availability zone 1c"
  type        = string
}

variable "env" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}
