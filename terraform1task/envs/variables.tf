variable "azs" {
  type = list(string)

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
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_cidr_block" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "docker_image" {
  type = string
}

variable "asg_max_size" {
  type = number
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_desired_capacity" {
  type    = number
  default = 1
}

variable "asg_instance_type" {
  type    = string
  default = "t2.micro"
}
