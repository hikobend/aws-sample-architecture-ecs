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
  retention_in_days    = local.elasticache.retention_in_days
  node_type            = local.elasticache.node_type
  num_cache_nodes      = local.elasticache.num_cache_nodes
  engine_version       = local.elasticache.engine_version
  env                  = var.env
}

module "aurora" {
  source                          = "../../modules/aurora"
  vpc_id                          = module.network.vpc_id
  private_subnet_1a               = module.network.private_subnet_1a
  private_subnet_1c               = module.network.private_subnet_1c
  database_user                   = data.aws_ssm_parameter.database_user.value
  database_password               = data.aws_ssm_parameter.database_password.value
  database_sg                     = module.network.database_sg
  family                          = local.aurora.family
  engine                          = local.aurora.engine
  engine_version                  = local.aurora.engine_version
  instance_class                  = local.aurora.instance_class
  enabled_cloudwatch_logs_exports = local.aurora.enabled_cloudwatch_logs_exports
  instances                       = local.aurora.instances
  env                             = var.env
}

module "ecr" {
  source = "../../modules/ecr"
  env    = var.env
}

module "ecs" {
  source = "../../modules/ecs"
  # frontend_sg       = module.network.frontend_sg
  alb_sg            = module.network.alb_sg
  public_subnet_1a  = module.network.public_subnet_1a
  public_subnet_1c  = module.network.public_subnet_1c
  private_subnet_1a = module.network.private_subnet_1a
  private_subnet_1c = module.network.private_subnet_1c
  env               = var.env
}

module "parameter_store" {
  source = "../../modules/parameter_store"
  env    = var.env
}
