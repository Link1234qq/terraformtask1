locals {
  name = "${var.name_prefix}-rds"
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
  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [var.rds_sg_id]
  skip_final_snapshot         = true
  deletion_protection         = false

  tags = {
    Name = local.name
  }
}
