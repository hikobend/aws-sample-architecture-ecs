module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  cidr                   = "10.0.0.0/24"
  azs                    = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets         = ["10.0.0.0/26", "10.0.0.64/26"]
  private_subnets        = ["10.0.0.128/26", "10.0.0.192/26"]
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
