output "monitoring_server_instance_id" {
  description = "Instance ID of monitoring server"
  value       = module.compute.instance_id
}

output "monitoring_server_public_ip" {
  description = "Public IP of monitoring server"
  value       = module.compute.public_ip
}