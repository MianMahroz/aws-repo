resource "aws_security_group" "db" {
  name        = "DBSG"
  description = "Allow MySQL from app tier"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  tags = {
    Name = "DBSG"
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "dbsubnetgroup"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "DBSubnetGroup"
  }
}

resource "aws_db_instance" "default" {
  identifier             = "mydb"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = "admin"
  password               = "MyDBPass123!"
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.db.name
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "DatabaseInstance"
  }
}