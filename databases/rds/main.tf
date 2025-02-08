# This resource designates the collection of subnets the DB can be provisioned in
resource "aws_db_subnet_group" "postgress_subnet_group" {
  name = var.rds_instance.db_subnet_group_name
  # The database requires to be located in 2 different subnets that are located
  # in 2 different availability zones
  subnet_ids = var.rds_instance.subnet_ids
  
  tags = {
    Name = var.rds_instance.db_subnet_group_name_tag_name
  }
}

# This resource will set configuration options on how the DB behaves
# In this example will log connections
resource "aws_db_parameter_group" "postgres_parameter_group" {
  name   = var.rds_instance.parameter_group_name
  family = var.rds_instance.parameter_group_family # The family needs to match the engine of the DB

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

# The following resource will create the DB
resource "aws_db_instance" "postgress" {
  identifier = var.rds_instance.identifier
  instance_class = var.rds_instance.instance_class
  allocated_storage = var.rds_instance.allocated_storage
  engine = var.rds_instance.engine
  engine_version = var.rds_instance.engine_version
  username = var.rds_instance.username
  password = var.rds_instance.password
  db_subnet_group_name = aws_db_subnet_group.postgress_subnet_group.name
  parameter_group_name = aws_db_parameter_group.postgres_parameter_group.name
  publicly_accessible = var.rds_instance.publicly_accessible
  skip_final_snapshot = var.rds_instance.skip_final_snapshot
}