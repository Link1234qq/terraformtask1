# Mandatory tags (app-name, environment, managed_by) come from provider default_tags in envs/.
#checkov:skip=CKV_AWS_378:Backend target group traffic is internal VPC HTTP; TLS is terminated at ALB edge.
resource "aws_lb_target_group" "this" {
  name        = var.name_prefix
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.name_prefix
  }
}

resource "aws_lb" "this" {
  name               = var.name_prefix
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets
  drop_invalid_header_fields = true
  enable_deletion_protection = true

  #checkov:skip=CKV2_AWS_28:WAF is not provisioned in this training environment.
  #checkov:skip=CKV2_AWS_20:HTTPS redirect requires ACM cert which is intentionally not configured now.
  access_logs {
    bucket  = var.access_logs_bucket_name
    prefix  = var.access_logs_prefix
    enabled = true
  }

  tags = {
    Name = var.name_prefix
  }
}

resource "aws_lb_listener" "http" {
  #checkov:skip=CKV_AWS_2:ACM certificate is intentionally absent in this environment.
  #checkov:skip=CKV_AWS_103:TLS policy is not applicable until HTTPS listener is enabled.
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  tags = {
    Name = var.name_prefix
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
