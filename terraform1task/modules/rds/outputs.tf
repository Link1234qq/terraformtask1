output "rds_instance_endpoint" {
    value = aws_db_instance.petclinic_database.endpoint
    description = "The endpoint of the RDS instance"
}