output "db_instance_id" {
  description = "RDS MySQL instance ID"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "RDS MySQL security group ID"
  value       = aws_security_group.this.id
}