module "prepare_tfstate" {
  source = "../modules/prepare_tfstate"
}

module "oidc" {
  source          = "../modules/oidc"
  account_id      = var.account_id
  user_name       = var.user_name
  repository_name = var.repository_name
}

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/20"
}
