module "dev_tfstate" {
  source = "../../modules/dev_tfstate"
}

module "network" {
  source          = "../../modules/network"
  cidr            = local.network.cidr
  azs             = local.network.azs
  public_subnets  = local.network.public_subnets
  private_subnets = local.network.private_subnets
  env             = var.env
}
