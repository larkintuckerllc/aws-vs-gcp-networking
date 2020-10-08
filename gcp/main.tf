locals {
  identifier = "project"
}

provider "google" {
  credentials = file("account.json")
  project = "aws-vs-gcp-networking" # REPLACE
}

module "vpc" {
  source = "./modules/vpc"
  identifier = local.identifier
}
