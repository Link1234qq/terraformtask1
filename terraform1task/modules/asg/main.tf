data "aws_ami" "ubuntu" {
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

data "aws_caller_identity" "current" {}

locals {
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/eo_role_boundary"
}

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "petclinic-${var.environment}-asg"

  min_size                  = 1
  max_size                  = var.max_size
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.public_subnets

  traffic_source_attachments = {
    alb = {
      traffic_source_identifier = var.target_group_arn
      traffic_source_type       = "elbv2"
    }
  }



  # Launch template
  launch_template_name        = "petclinic-${var.environment}-asg-launch-template"
  launch_template_description = "Launch template for petclinic-${var.environment}-asg"
  update_default_version      = true

  image_id          = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile   = true
  iam_role_permissions_boundary = var.permissions_boundary_arn
  iam_role_name                 = "petclinic-${var.environment}-asg-iam-role"
  iam_role_path                 = "/ec2/"
  iam_role_description          = "IAM role for petclinic-${var.environment}-asg"
  iam_role_tags = {
    CustomIamRole = "petclinic-${var.environment}-asg"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  security_groups = [var.asg_sg_id]


  # This will ensure imdsv2 is enabled, required, and a single hop which is aws security
  # best practices
  # See https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-4
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }


  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    docker_image = var.docker_image
    db_url       = var.db_url
    db_username  = var.db_username
    db_password  = var.db_password
    }
    )
  )
}
