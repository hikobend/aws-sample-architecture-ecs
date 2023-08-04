module "dev_tfstate" {
  source = "../../modules/dev_tfstate"
}

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = var.env
  }
}
