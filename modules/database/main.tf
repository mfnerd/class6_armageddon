provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_security_group" "allow_aurora" {
  name        = "Aurora_sg"
  description = "Security group for RDS Aurora"

  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_subnet_group" "mydb_subnet_group" {
  name = "mydb-subnet-group"
  subnet_ids = [
    var.region.aws_subnet.private1.id,
    var.region.aws_subnet.private2.id
  ]

  tags = {
    Name = "MyDBSubnetGroup"
  }
}
resource "aws_rds_cluster" "aurorards" {
  cluster_identifier     = "myauroracluster"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.12.0"
  database_name          = "MyDB"
  master_username        = "testAdmin"
  master_password        = "AdminTest4321"
  vpc_security_group_ids = [aws_security_group.allow_aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.mydb_subnet_group.name
  storage_encrypted      = false
  skip_final_snapshot    = true
}
resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier          = "muaurorainstance"
  cluster_identifier  = aws_rds_cluster.aurorards.id
  instance_class      = "db.t3.small"
  engine              = aws_rds_cluster.aurorards.engine
  engine_version      = aws_rds_cluster.aurorards.engine_version
  publicly_accessible = true
}