module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  cidr = var.cidr
  azs  = var.azs
  public_subnets = [
    {
      cidr_block              = "10.0.0.0/26"
      map_public_ip_on_launch = true
    },
    {
      cidr_block              = "10.0.0.64/26"
      map_public_ip_on_launch = true
    }
  ]
  private_subnets        = var.private_subnets
  public_subnet_names    = ["${var.env}-public-subnet-1a", "${var.env}-public-subnet-1c"]
  private_subnet_names   = ["${var.env}-private-subnet-1a", "${var.env}-private-subnet-1c"]
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  vpc_tags                 = { Name = "${var.env}-vpc" }
  public_route_table_tags  = { Name = "${var.env}-route-table-public" }
  private_route_table_tags = { Name = "${var.env}-route-table-private" }
  igw_tags                 = { Name = "${var.env}-internet-gateway" }
  nat_gateway_tags         = { Name = "${var.env}-nat-gateway" }
  nat_eip_tags             = { Name = "${var.env}-elatic-ip" }
}

# ALB(https)
module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-alb-sg"
  description = "ALB security group"
  vpc_id      = module.network.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  egress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.frontend_sg.security_group_id
    }
  ]
}

module "frontend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-frontend-sg"
  description = "Frontend security group"
  vpc_id      = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
  egress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.backend_sg.security_group_id
    }
  ]
}

module "backend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-backend-sg"
  description = "Backend security group"
  vpc_id      = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.frontend_sg.security_group_id
    }
  ]
  egress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.database_sg.security_group_id
    },
    {
      rule                     = "all-all"
      source_security_group_id = module.elasticache_sg.security_group_id
    }
  ]
}

module "database_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-database-sg"
  description = "Database security group"
  vpc_id      = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.backend_sg.security_group_id
    }
  ]
}

module "elasticache_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env}-elasticache-sg"
  description = "Elasticache security group"
  vpc_id      = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.backend_sg.security_group_id
    }
  ]
}
