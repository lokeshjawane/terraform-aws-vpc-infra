provider "aws" {
version = "~> 2.65"
}

terraform {
required_version = ">= 0.12"
}
module "vpc" {
source = "./modules/vpc"
  vpc_cidr    = "10.10.0.0/16"
  vpc_name    = "lokesh"
  environment = "poc"
  subnet_count =    //it will create 3 public subnet and 3 private subnet

}

output "Internal_subnet {
value = module.vpc.internal_subnets
}
output "External_subnet" {
value = module.vpc.external_subnets
}
output "VPCID" {
value = module.vpc.cidr_block
}
