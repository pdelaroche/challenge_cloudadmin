output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet" {
  description = "Print public subnet ID"
  value       = module.network.public_subnet
}