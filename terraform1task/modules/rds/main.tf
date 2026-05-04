resource "aws_db_subnet_group" "main" {
  name       = "petclinic-${var.environment}-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "petclinic${var.environment}-subnet-group"
  }
}

resource "aws_db_instance" "petclinic_database" {
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "petclinic${var.environment}database"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]
  skip_final_snapshot    = true
  deletion_protection    = false
  tags = {
    Name = "petclinic_${var.environment}_database"
  }
}