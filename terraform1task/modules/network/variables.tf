variable "azs" {
  type        = list(string)
  description = "Availability Zones"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "The list of private subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "The list of public subnets"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "environment" {
  type        = string
  description = "The environment"
}
