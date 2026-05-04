variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, prod), used for naming and tags"
}

variable "asg_sg_id" {
  type        = string
  description = "Security group ID for EC2 instances launched by the Auto Scaling Group"
}

variable "public_subnets" {
  type        = list(string)
  description = "Subnet IDs where ASG instances are launched"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB target group to register ASG instances with"
}

variable "docker_image" {
  type        = string
  description = "Docker image reference (registry/repo:tag) for the Petclinic container"
  default     = "sargeras147/petclinic:latest"
}

variable "db_url" {
  type        = string
  description = "Spring Boot JDBC URL for MySQL (e.g. jdbc:mysql://host:3306/dbname)"
}

variable "db_username" {
  type        = string
  description = "Database username passed to the application container"
}

variable "db_password" {
  type        = string
  description = "Database password passed to the application container"
  sensitive   = true
}

variable "permissions_boundary_arn" {
  type        = string
  description = "IAM permissions boundary ARN for the ASG instance role"
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in the Auto Scaling Group"
}
