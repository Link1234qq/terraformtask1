# Root modules: tier names (network, security, rds, alb, asg). Child modules follow role-based resource labels.
data "aws_caller_identity" "current" {}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  name_prefix = "${var.app_name}-${var.environment}"
  db_name     = "${replace(local.name_prefix, "-", "")}database"
}

module "network" {
  source          = "../modules/network"
  name_prefix     = local.name_prefix
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  vpc_cidr_block  = var.vpc_cidr_block
}

module "security" {
  source      = "../modules/security"
  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
}

module "rds" {
  source        = "../modules/rds"
  name_prefix   = local.name_prefix
  db_name       = local.db_name
  db_subnet_ids = module.network.private_subnets
  rds_sg_id     = module.security.rds_sg_id
  db_username   = var.db_username
  multi_az      = var.environment == "prod"
}

module "alb" {
  source         = "../modules/alb"
  name_prefix    = local.name_prefix
  vpc_id         = module.network.vpc_id
  alb_sg_id      = module.security.alb_sg_id
  public_subnets = module.network.public_subnets
  access_logs_bucket_name = var.alb_access_logs_bucket_name
  access_logs_prefix      = var.alb_access_logs_prefix
}

module "asg" {
  source           = "../modules/asg"
  name_prefix      = local.name_prefix
  app_name         = var.app_name
  asg_sg_id        = module.security.asg_sg_id
  public_subnets   = module.network.public_subnets
  target_group_arn = module.alb.target_group_arn
  db_url           = "jdbc:mysql://${module.rds.rds_instance_endpoint}/${local.db_name}"
  db_secret_arn    = module.rds.db_secret_arn
  docker_image     = var.docker_image
  account_id       = local.account_id
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  instance_type    = var.asg_instance_type
}
