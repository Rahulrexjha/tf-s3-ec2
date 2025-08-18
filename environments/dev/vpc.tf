module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name                 = "my-vpc"
  cidr                 = local.cidr
  azs                  = local.azs
  private_subnets      = local.private_subnets
  public_subnets       = local.public_subnets
  map_public_ip_on_launch = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags                 = local.tags
}
