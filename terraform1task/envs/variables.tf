variable "azs" {
  type        = list(string)
  description = "Availability Zones in us-east-1 for VPC subnets (e.g. us-east-1a, us-east-1b)"

  validation {
    condition = alltrue([
      for az in var.azs : contains([
        "us-east-1a",
        "us-east-1b",
        "us-east-1c",
        "us-east-1d",
        "us-east-1e",
        "us-east-1f"
      ], az)
    ])
    error_message = "Supported AZs are us-east-1a through us-east-1f."
  }
}

variable "app_name" {
  type        = string
  description = "Application base name used for resource naming and tags across all modules"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR blocks for private subnets (one per AZ, used for RDS and internal workloads)"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for public subnets (one per AZ, used for ALB and ASG instances)"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC (must encompass all public and private subnet CIDRs)"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, prod), passed to all child modules"
}

variable "managed_by" {
  type        = string
  description = "Owner or team responsible for resources (mandatory tag)"
}

variable "db_username" {
  type        = string
  description = "RDS master username; password is generated and stored by RDS in Secrets Manager (not in Terraform state)"
}

variable "docker_image" {
  type        = string
  description = "Docker image reference (registry/repo:tag) for the Petclinic container on ASG instances"
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instances in the Auto Scaling Group"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instances in the Auto Scaling Group"
  default     = 1
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instances in the Auto Scaling Group"
  default     = 1
}

variable "asg_instance_type" {
  type        = string
  description = "EC2 instance type for ASG instances"
  default     = "t2.micro"
}
