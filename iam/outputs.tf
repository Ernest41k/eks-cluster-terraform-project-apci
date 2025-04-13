output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_cluster_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_cluster_policy.id
}

output "eks_service_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_service_policy.id
}

output "eks_worker_role_AmazonEC2ContainerRegistryReadOnly" {
  value = aws_iam_role_policy_attachment.eks_worker_role_AmazonEC2ContainerRegistryReadOnly.id
}

output "eks_worker_instance_profile" {
  value = aws_iam_instance_profile.eks_workers_instance_profile.name
}

output "eks_cni_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_cni_policy.id
}

output "eks_worker_node_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_worker_node.id
}

output "eks_cw_agent_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_cw_agent.id
}

output "eks_worker_none_arn" {
  value = aws_iam_role.eks_worker_nodes_role.arn
}

output "eks_vpc_resource_comtroller_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_vpc_resource_comtroller_policy_attachment.id
}

output "eks_worker_node_arn" {
  value = aws_iam_role.eks_worker_nodes_role.arn
}
