module "vpc" {
  source                    = "terraform-aws-modules/vpc/aws"
  version                   = "~> v2.0"

  name                      = "terraform-ansible"
  #cidr                      = "10.0.0.0/16"
  cidr                      = "${lookup(var.cidr_ab, var.environment)}.0.0/16"
  #azs                       = ["us-east-1a", "us-east-1b", "us-east-1c"]
  #private_subnets           = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #public_subnets            = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  #database_subnets          = ["10.0.201.0/24", "10.0.202.0/24"]
  # Working with local variables
  private_subnets           = local.private_subnets
  database_subnets          = local.database_subnets
  public_subnets            = local.public_subnets

  azs                       = [
    "${lookup(var.region, var.environment)}a",
    "${lookup(var.region, var.environment)}b",
    "${lookup(var.region, var.environment)}c"
  ]

  # Could be
  # azs = local.availability_zones

  enable_nat_gateway        = false
  single_nat_gateway        = false
  one_nat_gateway_per_az    = false
  enable_vpn_gateway        = false

  enable_dns_hostnames      = true
  enable_dns_support        = true

  tags = {
    Terraform               = "true"
    Environment             = "dev"
    Owner                   = "William Munoz"
  }
}