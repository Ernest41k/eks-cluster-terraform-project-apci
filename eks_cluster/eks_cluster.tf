resource "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = [var.backend_subnet1, var.backend_subnet2]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on =[var.eks_cluster_policy_attachment, var.eks_service_policy_attachment]

}

#---------------------------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks_cluster_sg"
  description = "Allow SSH, HTTP Traffic"
  vpc_id      = var.main_vpc

  tags = {
    Name = "eks_cluster_sg"
  }
}

# CREATING INBOUND SECURITY GROUP FOR JUPITER SERVER-------------------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_api_server" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0" # Restrict to worker node IP range or CIDR if possible
}

resource "aws_vpc_security_group_ingress_rule" "allow_dns" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  from_port         = 53
  to_port           = 53
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0" # Restrict to internal VPC CIDR
}

# CREATING OUTBOUND SECURITY GROUP FOR JUPITER SERVER-------------------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv42" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}