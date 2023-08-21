module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_version = "1.27"
  cluster_name    = "EKSClusterNew1"
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  tags = {
    application = "collection"
  }
  cluster_endpoint_public_access = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  eks_managed_node_groups = {
    green = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }
}

