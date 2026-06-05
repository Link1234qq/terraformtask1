variable "name_prefix" {
  type        = string
  description = "Resource name prefix (app_name-environment), composed once in the root module"
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

variable "access_logs_bucket_name" {
  type        = string
  description = "S3 bucket name for ALB access logs"
}

variable "access_logs_prefix" {
  type        = string
  description = "Prefix path for ALB access logs"
  default     = "alb"
}
