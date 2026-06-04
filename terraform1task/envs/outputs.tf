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

output "db_secret_arn" {
  value       = module.rds.db_secret_arn
  description = "ARN of the RDS-managed Secrets Manager secret with database credentials"
}

output "account_id" {
  value       = local.account_id
  description = "AWS account ID (from aws_caller_identity data source in root module)"
}

output "name_prefix" {
  value       = local.name_prefix
  description = "Resource name prefix (app_name-environment) used across all child modules"
}
