# EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}




# EKS Worker Node Role------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "eks_worker_nodes_role" {
  name = "eks_worker_nodes_role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cw_agent" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_comtroller_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_policy" {
  policy_arn = "arn:aws:iam::450665609241:policy/AWSLoadBalancerControllerIAMPolicy"
  role       = aws_iam_role.eks_worker_nodes_role.name
}

resource "aws_iam_instance_profile" "eks_workers_instance_profile" {
  name = "eks-workers-instance-profile"
  role = aws_iam_role.eks_worker_nodes_role.name
}