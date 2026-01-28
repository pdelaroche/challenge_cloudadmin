output "instance_public_ip" {
  description = "Public IP address of monitoring instance"
  value       = aws_instance.monitoring.public_ip
}