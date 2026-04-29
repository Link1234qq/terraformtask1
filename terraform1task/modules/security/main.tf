resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound traffic from the internet to the ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb-sg-${var.environment}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress_rule" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "85.223.209.18/32"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_sg_egress_rule" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.asg_sg.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_security_group" "asg_sg" {
  name        = "asg_sg"
  description = "Allow inbound traffic from the ALB to the ASG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "asg_sg-${var.environment}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "asg_sg_ingress_rule" {
  security_group_id            = aws_security_group.asg_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "asg_sg_egress_rule" {
  security_group_id = aws_security_group.asg_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow inbound traffic from the ASG to the RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "rds_sg-${var.environment}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_sg_ingress_rule" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.asg_sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "rds_sg_egress_rule" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
