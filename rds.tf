resource "aws_db_instance" "doujou" {
  identifier = "${var.PROJECT_NAME}-doujou-rds"
#   final_snapshot_identifier = "${var.PROJECT_NAME}-doujou-rds-final-snapshot"
#   skip_final_snapshot = true
  allocated_storage       = "${var.RDS_ALLOCATED_STORAGE}"
  storage_type            = "gp2"
  engine                  = "${var.RDS_ENGINE}"
  engine_version          = "${var.ENGINE_VERSION}"
  instance_class          = "${var.DB_INSTANCE_CLASS}"
  backup_retention_period = "${var.BACKUP_RETENTION_PERIOD}"
  publicly_accessible     = "${var.PUBLICLY_ACCESSIBLE}"
  username                = "${var.RDS_USERNAME}"
  password                = "${var.RDS_PASSWORD}"
  vpc_security_group_ids  = ["${aws_security_group.doujou_rds.id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.rds_subnet_group.name}"
  multi_az                = "false"
}
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.PROJECT_NAME}_aurora_db_subnet_group"
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids = [
    "${aws_subnet.private_0.id}",
    "${aws_subnet.private_1.id}",
  ]
  tags {
    Name = "${var.PROJECT_NAME}-rds-Subnet-Group"
  }
}

