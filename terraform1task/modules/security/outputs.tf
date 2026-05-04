output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "Security group ID for the Application Load Balancer"
}

output "asg_sg_id" {
  value       = aws_security_group.asg_sg.id
  description = "Security group ID for instances in the Auto Scaling Group"
}

output "rds_sg_id" {
  value       = aws_security_group.rds_sg.id
  description = "Security group ID for the RDS MySQL instance"
}
