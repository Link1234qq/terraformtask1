module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name_prefix
  cidr = var.vpc_cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  manage_default_network_acl    = false
  manage_default_security_group = false
  manage_default_route_table    = false
  map_public_ip_on_launch       = true

  vpc_tags = {
    Name = var.name_prefix
  }

  public_subnet_tags = {
    Name = "${var.name_prefix}-public"
  }

  private_subnet_tags = {
    Name = "${var.name_prefix}-private"
  }

  igw_tags = {
    Name = var.name_prefix
  }

  default_route_table_tags = {
    Name = var.name_prefix
  }
}
