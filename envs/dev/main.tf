module "dev_tfstate" {
  source = "../../modules/dev_tfstate"
}

module "network" {
  source = "../../modules/network"
  env    = var.env
}
