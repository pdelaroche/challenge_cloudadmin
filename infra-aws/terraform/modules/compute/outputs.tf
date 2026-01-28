output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.monitoring.id
}

output "public_ip" {
  description = "Public IP address of monitoring instance"
  value       = aws_instance.monitoring.public_ip
}