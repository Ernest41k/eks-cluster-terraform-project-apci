variable "eks_cluster_role_arn" {
  type = string
}

variable "backend_subnet1" {
  type = string
}

variable "backend_subnet2" {
  type = string
}

variable "eks_cluster_policy_attachment" {
  type = string
}
variable "eks_service_policy_attachment" {
  type = string
}

variable "main_vpc" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "image_id" {
  type = string
}
