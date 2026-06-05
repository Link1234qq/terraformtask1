variable "name_prefix" {
  type        = string
  description = "Resource name prefix (app_name-environment), composed once in the root module"
}

variable "db_name" {
  type        = string
  description = "MySQL database name (composed in root module from name_prefix)"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the RDS DB subnet group (must be in the same VPC as RDS)"
}

variable "rds_sg_id" {
  type        = string
  description = "Security group ID attached to the RDS instance (typically allows MySQL from ASG)"
}

variable "db_username" {
  type        = string
  description = "Master username for the RDS MySQL instance (password is managed by RDS in Secrets Manager)"
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment for RDS instance"
  default     = true
}
