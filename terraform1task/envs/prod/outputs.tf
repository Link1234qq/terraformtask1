output "vpc_id" {
  value       = module.network.vpc_id
  description = "The ID of the VPC"
}

output "public_subnets" {
  value       = module.network.public_subnets
  description = "The IDs of the public subnets"
}

output "private_subnets" {
  value       = module.network.private_subnets
  description = "The IDs of the private subnets"
}

output "alb_sg_id" {
  value       = module.security.alb_sg_id
  description = "The ID of the ALB security group"
}

output "asg_sg_id" {
  value       = module.security.asg_sg_id
  description = "The ID of the ASG security group"
}

output "rds_sg_id" {
  value       = module.security.rds_sg_id
  description = "The ID of the RDS security group"
}

output "rds_instance_endpoint" {
  value       = module.rds.rds_instance_endpoint
  description = "The endpoint of the RDS instance"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "Public DNS of ALB"
}

output "autoscaling_group_name" {
  value       = module.asg.autoscaling_group_name
  description = "Name of ASG"
}
