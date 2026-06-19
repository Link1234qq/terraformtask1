output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "Security group ID for the Application Load Balancer"
}

output "asg_sg_id" {
  value       = aws_security_group.asg.id
  description = "Security group ID for instances in the Auto Scaling Group"
}

output "rds_sg_id" {
  value       = aws_security_group.rds.id
  description = "Security group ID for the RDS MySQL instance"
}
