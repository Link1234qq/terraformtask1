locals {
  alb_name = "${var.name_prefix}-alb"
  asg_name = "${var.name_prefix}-asg"
  rds_name = "${var.name_prefix}-rds"
}

resource "aws_security_group" "alb" {
  name        = local.alb_name
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = local.alb_name
  }
}

resource "aws_security_group" "asg" {
  name        = local.asg_name
  description = "Security group for ASG instances"
  vpc_id      = var.vpc_id

  tags = {
    Name = local.asg_name
  }
}

resource "aws_security_group" "rds" {
  name        = local.rds_name
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name = local.rds_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_from_office" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from office IP"
  cidr_ipv4         = var.alb_ingress_cidr
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags = {
    Name = "${local.alb_name}-http-from-office"
  }
}

resource "aws_vpc_security_group_ingress_rule" "asg_http_from_alb" {
  security_group_id            = aws_security_group.asg.id
  description                  = "Application port from ALB"
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"

  tags = {
    Name = "${local.asg_name}-http-from-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_mysql_from_asg" {
  security_group_id            = aws_security_group.rds.id
  description                  = "MySQL from application tier"
  referenced_security_group_id = aws_security_group.asg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"

  tags = {
    Name = "${local.rds_name}-mysql-from-asg"
  }
}
