resource "aws_db_subnet_group" "this" {
  name       = "${var.app_name}-${var.environment}-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.app_name}-${var.environment}-rds-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  engine                      = "mysql"
  instance_class              = "db.t3.micro"
  allocated_storage           = 20
  storage_type                = "gp2"
  db_name                     = "${var.app_name}${var.environment}database"
  username                    = var.db_username
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [var.rds_sg_id]
  skip_final_snapshot         = true
  deletion_protection         = false

  tags = {
    Name = "${var.app_name}-${var.environment}-rds-database"
  }
}
