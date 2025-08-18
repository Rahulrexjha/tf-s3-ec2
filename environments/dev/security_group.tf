module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC"
  vpc_id      = module.vpc.vpc_id
  depends_on  = [ module.vpc ]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp","ssh-tcp"]
}
