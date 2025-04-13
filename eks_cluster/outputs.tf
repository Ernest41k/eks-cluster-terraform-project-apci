output "eks_cluster_endpoint" {
 value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_sg" {
  value = aws_security_group.eks_cluster_sg.id
}
