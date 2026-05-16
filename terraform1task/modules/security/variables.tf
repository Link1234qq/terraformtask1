variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups are created"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, prod), used for tagging"
}

variable "app_name" {
  type        = string
  description = "Application base name used in mandatory resource tags"
}

variable "alb_ingress_cidr" {
  type        = string
  description = "CIDR allowed to reach the ALB on HTTP port 80"
  default     = "85.223.209.18/32"
}
