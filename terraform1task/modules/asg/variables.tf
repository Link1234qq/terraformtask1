variable "environment" {
  type = string
}
variable "asg_sg_id" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "target_group_arn" {
  type = string
}

variable "docker_image" {
  type = string
  default = "sargeras147/petclinic:latest"
}

variable "db_url" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
  sensitive = true
}

variable "permissions_boundary_arn" {
  type        = string
  description = "IAM permissions boundary ARN for created ASG role"
}

variable "max_size" {
  type        = number
  description = "Maximum ASG size for environment"
}