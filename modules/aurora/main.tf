resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "${var.env}-aurora-subnet-group"
  subnet_ids = [var.private_subnet_1a, var.private_subnet_1c]

  tags = {
    Name = "${var.env}-aurora-subnet-group"
  }
}
