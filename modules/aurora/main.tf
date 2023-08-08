resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "${var.env}-aurora-subnet-group"
  subnet_ids = [var.private_subnet_1a, var.private_subnet_1c]

  tags = {
    Name = "${var.env}-aurora-subnet-group"
  }
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.env}-aurora-parameter-group"
  family = "aurora-mysql8.0"

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "0"
  }

  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "pending-reboot"
  }
}

module "cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name                            = "${var.env}-aurora-cluster"
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  master_username                 = "terraform"
  master_password                 = "password"
  db_subnet_group_name            = aws_db_subnet_group.aurora_subnet_group.name
  db_parameter_group_name         = aws_db_parameter_group.parameter_group.name
  vpc_id                          = var.vpc_id
  port                            = 3306
  monitoring_interval             = 60
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  storage_encrypted               = true
  apply_immediately               = true
  skip_final_snapshot             = true
  deletion_protection             = false

  instances = {
    for ordinal_number in var.instances : ordinal_number => {
      instance_class = var.instance_class
      tags = {
        Name = "${var.env}-instance-${ordinal_number}"
      }
    }
  }

  # security_group_rules = {
  #   ex1_ingress = {
  #     source_security_group_id = var.database_sg_id
  #   }
  # }

  tags = {
    Name = "${var.env}-aurora-cluster"
  }
}
