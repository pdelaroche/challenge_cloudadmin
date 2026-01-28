output "monitoring_server_security_group_id" {
  description = "Security Group ID of monitoring server"
  value       = module.network.security_group_id
}

output "monitoring_server_public_ip" {
  description = "Public IP of monitoring server"
  value       = module.compute.instance_public_ip
}