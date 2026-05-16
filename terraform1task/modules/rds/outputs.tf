output "rds_instance_endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "The endpoint of the RDS instance"
}
