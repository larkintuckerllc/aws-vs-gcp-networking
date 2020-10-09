locals {
  identifier = "project"
}

provider "google" {
  credentials = file("account.json")
  project = "aws-vs-gcp-networking" # REPLACE
}

module "app" {
  source = "./modules/app"
  identifier = local.identifier
  network_name = module.vpc.network_name
  subnetwork_name = module.vpc.subnetwork_name
}

module "vpc" {
  source = "./modules/vpc"
  identifier = local.identifier
}
