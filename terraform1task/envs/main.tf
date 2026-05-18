# Root modules: tier names (network, security, rds, alb, asg). Child modules follow role-based resource labels.
data "aws_caller_identity" "current" {}

locals {
  permissions_boundary_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/eo_role_boundary"
}

module "network" {
  source          = "../modules/network"
  app_name        = var.app_name
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  vpc_cidr_block  = var.vpc_cidr_block
  environment     = var.environment
}

module "security" {
  source      = "../modules/security"
  app_name    = var.app_name
  vpc_id      = module.network.vpc_id
  environment = var.environment
}

module "rds" {
  source        = "../modules/rds"
  app_name      = var.app_name
  db_subnet_ids = module.network.private_subnets
  rds_sg_id     = module.security.rds_sg_id
  environment   = var.environment
  db_username   = var.db_username
  db_password   = var.db_password
}

module "alb" {
  source         = "../modules/alb"
  app_name       = var.app_name
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  alb_sg_id      = module.security.alb_sg_id
  public_subnets = module.network.public_subnets
}

module "asg" {
  source                   = "../modules/asg"
  app_name                 = var.app_name
  environment              = var.environment
  managed_by               = var.managed_by
  asg_sg_id                = module.security.asg_sg_id
  public_subnets           = module.network.public_subnets
  target_group_arn         = module.alb.target_group_arn
  db_url                   = "jdbc:mysql://${module.rds.rds_instance_endpoint}/${var.app_name}${var.environment}database"
  db_username              = var.db_username
  db_password              = var.db_password
  docker_image             = var.docker_image
  permissions_boundary_arn = local.permissions_boundary_arn
  min_size                 = var.asg_min_size
  max_size                 = var.asg_max_size
  desired_capacity         = var.asg_desired_capacity
  instance_type            = var.asg_instance_type
}
