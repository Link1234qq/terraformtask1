locals {
  vpc_name = "${var.app_name}-vpc-${var.environment}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = var.vpc_cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  manage_default_network_acl    = false
  manage_default_security_group = false
  manage_default_route_table    = false
  map_public_ip_on_launch       = true

  vpc_tags = {
    Name = local.vpc_name
  }

  public_subnet_tags = {
    Name = "${var.app_name}-${var.environment}-public"
  }

  private_subnet_tags = {
    Name = "${var.app_name}-${var.environment}-private"
  }

  igw_tags = {
    Name = "${var.app_name}-${var.environment}-igw"
  }

  default_route_table_tags = {
    Name = "${var.app_name}-${var.environment}-default-rt"
  }
}
