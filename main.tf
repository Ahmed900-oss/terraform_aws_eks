provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["C:/Users/Ahmed/.aws/credentials"]
}

variable "vpc_cidr_block" {}
variable "private_subnets_cidr_block" {}
variable "public_subnets_cidr_block" {}

data "aws_availability_zones" "azs" {}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.8.1"
  name                 = "myapp-vpc"
  cidr                 = var.vpc_cidr_block
  private_subnets      = var.private_subnets_cidr_block
  public_subnets       = var.public_subnets_cidr_block
  azs                  = data.aws_availability_zones.azs.names
  enable_nat_gateway   = true
  enable_dns_hostnames = true
  single_nat_gateway   = true
  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }
}
