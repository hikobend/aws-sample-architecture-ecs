module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  cidr                   = var.cidr
  azs                    = var.azs
  public_subnets         = var.public_subnets
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
  ingress_rules       = ["https-443-tcp"]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "front_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${var.env}-front-sg"

  vpc_id = module.network.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
}