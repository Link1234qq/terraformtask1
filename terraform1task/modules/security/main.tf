# Reusable SG module for group + rules passed as maps.
# Cross-SG rules below reference module outputs (ALB <-> ASG, RDS <- ASG) to avoid module dependency cycles inside `sg`.
module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "alb-sg-${var.environment}"
  description = "Security group for alb with HTTP ports open within VPC"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["85.223.209.18/32"]
}


module "asg_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-8080"
  version = "~> 5.0"

  name        = "asg-sg-${var.environment}"
  description = "Security group for asg with HTTP ports open to the ALB "
  vpc_id      = var.vpc_id

}

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/mysql"
  version = "~> 5.0"

  name        = "rds-sg-${var.environment}"
  description = "Security group for rds with MySQL ports open to the ASG"
  vpc_id      = var.vpc_id
}


resource "aws_vpc_security_group_ingress_rule" "rds_from_asg_3306" {
  security_group_id            = module.rds_sg.security_group_id
  referenced_security_group_id = module.asg_sg.security_group_id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}


# module "alb_sg" {
#   source = "../sg"

#   name        = "alb-sg-${var.environment}"
#   description = "Allow inbound traffic from the internet to the ALB"
#   vpc_id      = var.vpc_id

#   tags = {
#     Name = "alb-sg-${var.environment}"
#   }

#   ingress_rules = {
#     office_http = {
#       description = "HTTP from office IP"
#       cidr_ipv4   = "85.223.209.18/32"
#       from_port   = 80
#       to_port     = 80
#       ip_protocol = "tcp"
#     }
#   }

#   egress_rules = {}
# }

# module "asg_sg" {
#   source = "../sg"

#   name        = "asg-sg-${var.environment}"
#   description = "Allow inbound traffic from the ALB to the ASG"
#   vpc_id      = var.vpc_id

#   tags = {
#     Name = "asg-sg-${var.environment}"
#   }

#   ingress_rules = {}

#   egress_rules = {
#     all = {
#       description = "All outbound (updates, Docker pull, etc.)"
#       cidr_ipv4   = "0.0.0.0/0"
#       ip_protocol = "-1"
#     }
#   }
# }

# module "rds_sg" {
#   source = "../sg"

#   name        = "rds-sg-${var.environment}"
#   description = "Allow inbound traffic from the ASG to the RDS"
#   vpc_id      = var.vpc_id

#   tags = {
#     Name = "rds-sg-${var.environment}"
#   }

#   ingress_rules = {}

#   egress_rules = {
#     all = {
#       description = "All outbound"
#       cidr_ipv4   = "0.0.0.0/0"
#       ip_protocol = "-1"
#     }
#   }
# }

# resource "aws_vpc_security_group_egress_rule" "alb_to_asg_8080" {
#   description                  = "Forward HTTP traffic from ALB to application on ASG"
#   security_group_id            = module.alb_sg.security_group_id
#   referenced_security_group_id = module.asg_sg.security_group_id
#   from_port                    = 8080
#   to_port                      = 8080
#   ip_protocol                  = "tcp"
# }

# resource "aws_vpc_security_group_ingress_rule" "asg_from_alb_8080" {
#   description                  = "Application port from ALB"
#   security_group_id            = module.asg_sg.security_group_id
#   referenced_security_group_id = module.alb_sg.security_group_id
#   from_port                    = 8080
#   to_port                      = 8080
#   ip_protocol                  = "tcp"
# }

# resource "aws_vpc_security_group_ingress_rule" "rds_from_asg_3306" {
#   description                  = "MySQL from application tier"
#   security_group_id            = module.rds_sg.security_group_id
#   referenced_security_group_id = module.asg_sg.security_group_id
#   from_port                    = 3306
#   to_port                      = 3306
#   ip_protocol                  = "tcp"
# }
