variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}
variable "env_01" {
  description = "The deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}
