data "aws_caller_identity" "current" {}

locals {
  permissions_boundary_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/eo_role_boundary"
}

module "network" {
  source          = "../../modules/network"
  azs             = var.azs
  vpc_name        = var.vpc_name
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  vpc_cidr_block  = var.vpc_cidr_block
  environment     = var.environment
}

module "security" {
  source      = "../../modules/security"
  vpc_id      = module.network.vpc_id
  environment = var.environment
}

module "rds" {
  source        = "../../modules/rds"
  db_subnet_ids = module.network.private_subnets
  rds_sg_id     = module.security.rds_sg_id
  environment   = var.environment
  db_username   = var.db_username
  db_password   = var.db_password
}

module "alb" {
  source         = "../../modules/alb"
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  alb_sg_id      = module.security.alb_sg_id
  public_subnets = module.network.public_subnets
}

module "asg" {
  source                   = "../../modules/asg"
  environment              = var.environment
  asg_sg_id                = module.security.asg_sg_id
  public_subnets           = module.network.public_subnets
  target_group_arn         = module.alb.target_group_arn
  db_url                   = "jdbc:mysql://${module.rds.rds_instance_endpoint}/petclinicproddatabase"
  db_username              = var.db_username
  db_password              = var.db_password
  docker_image             = var.docker_image
  permissions_boundary_arn = local.permissions_boundary_arn
  max_size                 = var.asg_max_size
}
