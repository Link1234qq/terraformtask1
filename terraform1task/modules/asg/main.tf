data "aws_region" "current" {}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_iam_role" "asg" {
  name                 = "${var.app_name}-${var.environment}-asg-iam-role"
  path                 = "/ec2/"
  description          = "IAM role for ${var.app_name}-${var.environment}-asg"
  permissions_boundary = var.permissions_boundary_arn

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name          = "${var.app_name}-${var.environment}-asg-iam-role"
    CustomIamRole = "${var.app_name}-${var.environment}-asg"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.asg.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "db_secret_read" {
  name = "${var.app_name}-${var.environment}-db-secret-read"
  role = aws_iam_role.asg.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "secretsmanager:GetSecretValue"
      Resource = [
        var.db_secret_arn,
        "${var.db_secret_arn}-*"
      ]
    }]
  })
}

resource "aws_iam_instance_profile" "asg" {
  name = "${var.app_name}-${var.environment}-asg-instance-profile"
  path = "/ec2/"
  role = aws_iam_role.asg.name

  tags = {
    Name = "${var.app_name}-${var.environment}-asg-instance-profile"
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.app_name}-${var.environment}-lt-"
  description   = "Launch template for ${var.app_name}-${var.environment}-asg"
  image_id      = data.aws_ami.this.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.asg_sg_id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.asg.arn
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    app_name       = var.app_name
    docker_image   = var.docker_image
    db_url         = var.db_url
    db_secret_arn  = var.db_secret_arn
    aws_region     = data.aws_region.current.id
  }))

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring {
    enabled = true
  }

  update_default_version = true

  tag_specifications {
    resource_type = "instance"
    tags = {
      app-name    = var.app_name
      environment = var.environment
      managed_by  = var.managed_by
      Name        = "${var.app_name}-${var.environment}-asg-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      app-name    = var.app_name
      environment = var.environment
      managed_by  = var.managed_by
      Name        = "${var.app_name}-${var.environment}-asg-volume"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-launch-template"
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.app_name}-${var.environment}-asg"
  vpc_zone_identifier       = var.public_subnets
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.app_name}-${var.environment}-asg"
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = {
      app-name    = var.app_name
      environment = var.environment
      managed_by  = var.managed_by
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  dynamic "tag" {
    for_each = {
      Name = "${var.app_name}-${var.environment}-asg-instance"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
