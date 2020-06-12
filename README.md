
# Summary
This terraform module is to manage project creation on AWS platform which calculate the subnet address based on given VPC CIRD and variable value.



## Variables
|Variable|Description|
|-|-|
|vpc_name|(required) Name of the VP|
|vpc_cidr|(required) CIDR for the VPC network|
|external_subnets|(optional) List of hash, to create public subnets, if not specified then module will calculate subnets|
|internal_subnets|(optional) List of hash, to create private subnets, if not specified then module will calculate subnets|
|environment|(required) Envronment name like dev,test|
|enable_dns_hostnames|(optional) enable dns hostname support, by default "true"|
|enable_dns_support|(optional) enable dns support, by default "true"|
|subnet_count|(optional) if this is set, then it module will create subnet x number of public subnets and x number of private subnets, this is mutually exclusive with external_subnets and internal_subnets vars. **subnet_count value cannot be more than number of Availability zones in region**|

**Note**
If list of HASH(external_subnets, internal_subnets) is not provided, then TF create public and private subnets based on number of subnet_count available. 

Use **subnet_count** if you sure about fix number of subnets, then go ahead and set this value else follow external_subnets, internal_subnets vars.

## Output
|Variable|Description|
|-|-|
|cidr_block| vpc coidr block|
|id| vpc id|
|external_subnets| external subnet ids |
|internal_subnets| internal subnet ids |
|external_autosubnets| auto calculated cidr external subnet ids |
|internal_autosubnets| auto calculated cidr iinternal subnet ids |


## Requirements
|Name|Version|
|-|-|
|terraform|>= 0.12|
|aws provider|~> 2.65|

## Examples

### Create VPC with auto subnets calculation
```
provider "aws"{
}

module "test-vpc" {
source = "modules/vpc"
vpc_cidr = "172.168.0.0/16"
environment  = "prod"
vpc_name = "vpc-name"
subnet_count = 4
}


output "external_subnets" {
value = module.vpc.external_autosubnets
}

output "intenal_subnets" {
value = module.vpc.internal_autosubnets
}

output "vpc_cidr" {
value = module.vpc.cidr_block
}
```

### Create VPC with custom preference

```
provider "aws"{
}

module "test-vpc" {
source = "modules/vpc"
vpc_cidr = "172.30.0.0/16"
environment  = "prod"
vpc_name = "vpc-name"
external_subnets = [
{name = "pubsub-1", cidr = "172.30.0.0/20", az = "ap-southeast-1a"},
{name = "pubsub-2", cidr = "172.30.32.0/20", az = "ap-southeast-1b"},
{name = "pubsub-3", cidr = "172.30.64.0/20", az = "ap-southeast-1c"}
]

internal_subnets = [
{name = "prisub-1", cidr = "172.30.96.0/20", az = "ap-southeast-1a"},
{name = "prisub-2", cidr = "172.30.128.0/20", az = "ap-southeast-1b"},
{name = "prisub-3", cidr = "172.30.150.0/20", az = "ap-southeast-1c"}
]
}

output "external_subnets" {
value = module.vpc.external_subnets
}

output "intenal_subnets" {
value = module.vpc.internal_subnets
}

output "vpc_cidr" {
value = module.vpc.cidr_block
}

output "vpc_id" {
value = module.vpc.id
}
```
