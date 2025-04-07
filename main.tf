provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
  tags = local.project_tags
  subnet_cidr_block = var.subnet_cidr_block
  vpc_cidr_block = var.vpc_cidr_block
  availability_zone = var.availability_zone
}