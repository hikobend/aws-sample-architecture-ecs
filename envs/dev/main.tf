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

module "elasticache" {
  source               = "../../modules/elasticache"
  private_subnet_1a    = module.network.private_subnet_1a
  private_subnet_1c    = module.network.private_subnet_1c
  availability_zone_1a = module.network.availability_zone_1a
  redis_sg_id          = module.network.redis_sg_id
  env                  = var.env
}
