# Resource naming: snake_case; role-based labels (no app name). Primary resource per type uses "this".
locals {
  common_tags = {
    app-name    = var.app_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "aws_lb_target_group" "this" {
  name        = "${var.app_name}-${var.environment}-tg"
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

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-tg"
  })
}

resource "aws_lb" "this" {
  name               = "${var.app_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-alb"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-alb-listener"
  })

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
