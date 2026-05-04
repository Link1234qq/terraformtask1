variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups are created"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g. dev, prod), used for tagging"
}
