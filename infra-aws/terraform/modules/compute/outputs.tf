output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.monitoring.id
}

output "public_ip" {
  description = "Public IP monitoring server"
  value       = aws_instance.monitoring.public_ip
}
  