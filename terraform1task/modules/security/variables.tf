variable "name_prefix" {
  type        = string
  description = "Resource name prefix (app_name-environment), composed once in the root module"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups are created"
}

variable "alb_ingress_cidr" {
  type        = string
  description = "CIDR allowed to reach the ALB on HTTP port 80"
  default     = "85.223.209.18/32"
}
