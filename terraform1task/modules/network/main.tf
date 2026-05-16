# Resource naming: child community module "vpc"; AWS names use app_name and environment.
locals {
  vpc_name = "${var.app_name}-vpc-${var.environment}"

  common_tags = {
    app-name    = var.app_name
    environment = var.environment
    managed_by  = "terraform"
  }
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

  tags = local.common_tags

  vpc_tags = merge(local.common_tags, {
    Name = local.vpc_name
  })

  public_subnet_tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-public"
  })

  private_subnet_tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-private"
  })

  igw_tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-igw"
  })

  default_route_table_tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-default-rt"
  })
}
