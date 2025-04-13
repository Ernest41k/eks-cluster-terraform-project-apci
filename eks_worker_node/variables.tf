variable "frontend_subnet1" {
  type = string
}

variable "frontend_subnet2" {
  type = string
}

variable "eks_worker_instance_profile" {
  type = string
}

variable "main_vpc" {
  type = string
}
variable "tags" {
  type = map(string)
}

variable "eks_worker_node_arn" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "eks_cluster_sg" {
  type = string
}

variable "cluster_ca_certificate" { # The CA certificate of the EKS cluster
  type = string
}

variable "cluster_name" {
  type = string
}

variable "image_id" {
  type = string
}

variable "eks_cluster_endpoint" {
    type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "instance_type" {
  type = string
}