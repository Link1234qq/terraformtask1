variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, prod), used for naming and tags"
}

variable "app_name" {
  type        = string
  description = "Application base name used in ALB and target group naming"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the Application Load Balancer and target group are deployed"
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID attached to the Application Load Balancer"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet IDs for ALB placement (must span at least two AZs for ALB)"
}
