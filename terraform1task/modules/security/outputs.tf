output "alb_sg_id" {
  value       = module.alb_sg.security_group_id
  description = "Security group ID for the Application Load Balancer"
}

output "asg_sg_id" {
  value       = module.asg_sg.security_group_id
  description = "Security group ID for instances in the Auto Scaling Group"
}

output "rds_sg_id" {
  value       = module.rds_sg.security_group_id
  description = "Security group ID for the RDS MySQL instance"
}
