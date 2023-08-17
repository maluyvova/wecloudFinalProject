terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-west-1"
}



module "terraform-vpc-module" {
  source                     = "./modules/vpc"
  vpc_cidr_block             = var.vpc_cidr_block
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
}

module "terraform-eks-module" {
  source     = "./modules/eks"
  vpc_id     = module.terraform-vpc-module.vpc.vpc_id
  subnet_ids = module.terraform-vpc-module.vpc.private_subnets
}

module "terraform-mongo" {
  source            = "./modules/mongo"
  env_prefix        = var.env_prefix
  my_ip             = var.my_ip
  instance_type     = var.instance_type
  image_name        = var.image_name
  cidr_blocks       = var.cidr_blocks
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  public_key = var.public_key
}
