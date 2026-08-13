resource "aws_db_subnet_group" "this" {
  name = "${var.identifier}-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = "${var.identifier}-subnet-group"
    Project = var.project_tag
  }
}

resource "aws_security_group" "this" {
  name        = "${var.identifier}-sg"
  description = "Security group for ${var.identifier} MySQL"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.identifier}-sg"
    Project = var.project_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.eks_node_security_group_id

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"

  description = "Allow MySQL access from EKS worker nodes"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}

resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.username
  password = var.password

  port = 3306

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  publicly_accessible = false

  # Temporary value because of the AWS account restriction.
  # Restore to 7 before assessment submission.
  backup_retention_period = 1

  backup_window = "04:00-05:00"

  deletion_protection = true

  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.identifier}-final"

  multi_az = false

  auto_minor_version_upgrade = true

  apply_immediately = true

  tags = {
    Name    = var.identifier
    Project = var.project_tag
  }
}