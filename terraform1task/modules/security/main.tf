# Resource naming: snake_case; tier labels (alb, asg, rds); rules as {tier}_{purpose}.
locals {
  common_tags = {
    app-name    = var.app_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.app_name}-${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-alb-sg"
  })
}

resource "aws_security_group" "asg" {
  name        = "${var.app_name}-${var.environment}-asg-sg"
  description = "Security group for ASG instances"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-asg-sg"
  })
}

resource "aws_security_group" "rds" {
  name        = "${var.app_name}-${var.environment}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-rds-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_from_office" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from office IP"
  cidr_ipv4         = var.alb_ingress_cidr
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-alb-http-from-office"
  })
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow outbound from ALB"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-alb-egress-all"
  })
}

resource "aws_vpc_security_group_ingress_rule" "asg_http_from_alb" {
  security_group_id            = aws_security_group.asg.id
  description                  = "Application port from ALB"
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-asg-http-from-alb"
  })
}

resource "aws_vpc_security_group_egress_rule" "asg_egress_all" {
  security_group_id = aws_security_group.asg.id
  description       = "Allow outbound from ASG (updates, Docker pull, RDS)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-asg-egress-all"
  })
}

resource "aws_vpc_security_group_ingress_rule" "rds_mysql_from_asg" {
  security_group_id            = aws_security_group.rds.id
  description                  = "MySQL from application tier"
  referenced_security_group_id = aws_security_group.asg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-rds-mysql-from-asg"
  })
}

resource "aws_vpc_security_group_egress_rule" "rds_egress_all" {
  security_group_id = aws_security_group.rds.id
  description       = "Allow outbound from RDS"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-rds-egress-all"
  })
}
