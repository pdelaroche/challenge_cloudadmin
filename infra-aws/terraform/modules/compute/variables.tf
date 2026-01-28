variable "env_01" {
  description = "The deployment environment"
  type        = string
}

variable "public_subnet" {
  description = "Public subnet ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string

}