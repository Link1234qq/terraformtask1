# Resource naming: snake_case; role-based labels (no app name). Primary resource per type uses "this".
locals {
  common_tags = {
    app-name    = var.app_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.app_name}-${var.environment}-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-rds-subnet-group"
  })
}

resource "aws_db_instance" "this" {
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "${var.app_name}${var.environment}database"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]
  skip_final_snapshot    = true
  deletion_protection    = false

  tags = merge(local.common_tags, {
    Name = "${var.app_name}-${var.environment}-rds-database"
  })
}
