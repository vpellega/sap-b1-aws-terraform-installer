resource "aws_db_instance" "sap_b1_rds" {
  identifier          = "${var.project_name}-${var.environment}-rds"
  allocated_storage   = 20
  storage_type        = "gp3"
  instance_class      = "db.t3.medium"
  engine              = var.sql_engine
  engine_version      = var.sql_engine_version
  username            = var.sql_username
  password            = var.sql_password
  port                = 1433
  publicly_accessible = true
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true

  vpc_security_group_ids = [aws_security_group.sap_b1_rds_sg.id]

  tags = merge(
    { Name = "${var.project_name}-${var.environment}-rds" },
    { (var.instance_tag_key) = var.instance_tag_value }
  )
}