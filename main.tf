provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks_cluster.cluster_name # Change to your EKS cluster name
}

provider "kubernetes" {
  host                   = module.eks_cluster.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

module "vpc" {
  source            = "./vpc"
  availability_zone = var.availability_zone
  tags              = local.project_tags
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}

module "iam" {
  source = "./iam"
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: ${module.iam.eks_worker_node_arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
    YAML
  }
}

module "eks_cluster" {
  source                        = "./eks_cluster"
  eks_cluster_policy_attachment = module.iam.eks_cluster_policy_attachment
  eks_service_policy_attachment = module.iam.eks_service_policy_attachment
  backend_subnet1               = module.vpc.backend_subnet1
  backend_subnet2               = module.vpc.backend_subnet2
  main_vpc                      = module.vpc.main_vpc
  eks_cluster_role_arn          = module.iam.eks_cluster_role_arn
  eks_cluster_name              = var.eks_cluster_name
  key_name                      = var.key_name
  image_id                      = var.image_id
}

module "eks_worker_node" {
  source                      = "./eks_worker_node"
  cluster_name                = var.eks_cluster_name
  eks_cluster_name            = var.eks_cluster_name
  frontend_subnet1            = module.vpc.frontend_subnet1
  frontend_subnet2            = module.vpc.frontend_subnet2
  eks_cluster_sg              = module.eks_cluster.eks_cluster_sg
  main_vpc                    = module.vpc.main_vpc
  key_name                    = var.key_name
  eks_cluster_endpoint        = module.eks_cluster.eks_cluster_endpoint
  cluster_ca_certificate      = module.eks_cluster.cluster_ca_certificate
  image_id                    = var.image_id
  eks_worker_instance_profile = module.iam.eks_worker_instance_profile
  eks_worker_node_arn         = module.iam.eks_worker_node_arn
  tags                        = local.project_tags
  vpc_cidr_block              = var.vpc_cidr_block
  instance_type               = var.instance_type
}
