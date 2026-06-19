locals {
  name = "${var.name_prefix}-rds"
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name = "${local.name}-enhanced-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_subnet_group" "this" {
  name       = local.name
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = local.name
  }
}

resource "aws_db_instance" "this" {
  engine                      = "mysql"
  instance_class              = "db.t3.micro"
  allocated_storage           = 20
  storage_type                = "gp2"
  storage_encrypted           = true
  db_name                     = var.db_name
  username                    = var.db_username
  auto_minor_version_upgrade  = true
  copy_tags_to_snapshot       = true
  iam_database_authentication_enabled = true
  enabled_cloudwatch_logs_exports     = ["error", "general", "slowquery"]
  monitoring_interval                 = 60
  monitoring_role_arn                 = aws_iam_role.rds_enhanced_monitoring.arn
  manage_master_user_password = true
  multi_az                    = var.multi_az
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [var.rds_sg_id]
  skip_final_snapshot         = true
  deletion_protection         = true

  tags = {
    Name = local.name
  }
}
