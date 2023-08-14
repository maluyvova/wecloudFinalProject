data "aws_availability_zones" "azs" {
  state = "available"
}
module "EKS-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  # insert the 21 required variables here
  name                 = "EKS-vpc"
  cidr                 = var.vpc_cidr_block
  private_subnets      = var.private_subnet_cidr_blocks
  public_subnets       = var.public_subnet_cidr_blocks
  azs                  = slice(data.aws_availability_zones.azs.names, 0, 2)
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  tags = {
    "kubernetes.io/cluster/EKS" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/EKS" = "shared"
    "kubernetes.ip/role/elb"    = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/EKS"       = "shared"
    "kubernetes.ip/role/internal-elb" = 1
  }
}
