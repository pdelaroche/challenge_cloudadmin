variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "env_01" {
  description = "The deployment environment"
  type        = string
  validation {
    condition     = var.env_01 == "dev"
    error_message = "Error!! Environment not allowed, try again"
  }

}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_pair_name" {
  description = "SSH key to access monitoring instance"
  type        = string
}