locals {
  identifier = "project"
}

provider "aws" {
  region = "us-east-1"
}

module "app" {
  source             = "./modules/app"
  identifier         = local.identifier
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  security_group     = module.vpc.security_group
  vpc_id             = module.vpc.vpc_id
}

module "vpc" {
  source     = "./modules/vpc"
  identifier = local.identifier
}
