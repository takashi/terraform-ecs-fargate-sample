variable "db_user" {}
variable "db_pass" {}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [
    "${aws_subnet.rds.*.id}"
  ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.6.39"
  instance_class    = "db.t2.micro"

  name                 = "DBNAME"
  username             = "${var.db_user}"
  password             = "${var.db_pass}"
  parameter_group_name = "default.mysql5.6"

  multi_az                   = false
  backup_retention_period    = "7"
  apply_immediately          = true
  auto_minor_version_upgrade = true
  vpc_security_group_ids     = ["${aws_security_group.db.id}"]
  db_subnet_group_name       = "${aws_db_subnet_group.default.name}"
}
