resource "aws_lb_target_group" "petclinic" {
  name        = "petclinic-${var.environment}-tg"
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
}

resource "aws_lb" "petclinic_alb" {
  name               = "petclinic-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "petclinic_alb_listener" {
  load_balancer_arn = aws_lb.petclinic_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.petclinic.arn
  }
}
