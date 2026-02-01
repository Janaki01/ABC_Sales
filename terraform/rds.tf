resource "aws_db_subnet_group" "db_subnet" {
  name = "etl-db-subnet-group"
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
    # aws_subnet.private_subnet_1.id,
    # aws_subnet.private_subnet_2.id
  ]
  tags = {
    Name = "etl-db-subnet-group"
  }
}
resource "aws_db_instance" "postgres" {
  identifier             = "etl-postgres"
  engine                 = "postgres"
  engine_version         = "14"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = var.db_username
  password               = var.db_password
#   db_name                = "etl_db"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}