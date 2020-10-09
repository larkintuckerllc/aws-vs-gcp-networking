locals {
  identifier = "project"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source             = "./modules/vpc"
  identifier         = local.identifier
}
