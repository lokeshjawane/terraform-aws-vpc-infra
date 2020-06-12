provider "aws" {
version = "~> 2.65"
}

terraform {
required_version = ">= 0.12"
}
module "vpc" {
source = "./modules/vpc"
  vpc_cidr    = "10.10.0.0/16"
  vpc_name    = "infra"
  environment = "poc"

  external_subnets = [{name = "public1",cidr = "10.10.32.0/19",az = "us-east-1a"},{name = "public2",cidr = "10.10.64.0/19",az = "us-east-1b"}]
  internal_subnets = [{name = "private1",cidr = "10.10.128.0/19",az = "us-east-1a"},{name = "private2",cidr = "10.10.96.0/19",az = "us-east-1b"}]
}
