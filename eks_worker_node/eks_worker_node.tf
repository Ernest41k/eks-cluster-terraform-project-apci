# resource "aws_launch_configuration" "eks_workers_launch" {
#   name              = var.eks_cluster_name
#   image_id          = var.image_id # Amazon eks public AMI
#   instance_type     = var.instance_type # a1.medium  "c7g.medium"
#   iam_instance_profile = var.eks_worker_instance_profile
#   security_groups   = [aws_security_group.eks_workers_sg.id]
#   key_name          = var.key_name
#   associate_public_ip_address = true  

#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 20
#   }
  
# #   user_data = base64decode(<<-EOF
# #     #!/bin/bash
# #     set -o xtrace
# #     /etc/eks/bootstrap.sh ${var.eks_cluster_name} \
# #       --apiserver-endpoint ${var.eks_cluster_endpoint} \
# #       --b64-cluster-ca ${var.cluster_ca_certificate}
# #   EOF
# #   )
# # }

#   user_data = <<-EOF
#     #!/bin/bash
#     set -o xtrace
#     /etc/eks/bootstrap.sh ${var.eks_cluster_name} \
#       --apiserver-endpoint ${var.eks_cluster_endpoint} \
#       --b64-cluster-ca ${var.cluster_ca_certificate}
#   EOF
#  }



# resource "aws_autoscaling_group" "eks_workers" {
#   desired_capacity                    = 2
#   max_size                            = 3
#   min_size                            = 1
#   vpc_zone_identifier                 = [var.frontend_subnet1, var.frontend_subnet2] 
#   launch_configuration                = aws_launch_configuration.eks_workers_launch.id

#   tag {
#     key                       = "kubernetes.io/cluster/${var.cluster_name}"
#     value                     = "owned"
#     propagate_at_launch       = true 
#   }

#   depends_on = [
#     aws_launch_configuration.eks_workers_launch
#   ]          
# }

resource "aws_launch_template" "eks_workers_lt" {
  name_prefix   = "${var.eks_cluster_name}-lt-"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.eks_worker_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.eks_workers_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = "gp2"
      volume_size = 20
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.eks_cluster_name} \
      --apiserver-endpoint ${var.eks_cluster_endpoint} \
      --b64-cluster-ca ${var.cluster_ca_certificate}
  EOF
  )
}

resource "aws_autoscaling_group" "eks_workers" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [var.frontend_subnet1, var.frontend_subnet2]

  launch_template {
    id      = aws_launch_template.eks_workers_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  depends_on = [
    aws_launch_template.eks_workers_lt
  ]
}

resource "aws_security_group" "eks_workers_sg" {
  name        = "eks_workers_sg"
  description = "Allow SSH, HTTP Traffic"
  vpc_id      = var.main_vpc

  tags = {
    Name = "eks_workers_sg"
  }
}

# CREATING INBOUND SECURITY GROUP FOR JUPITER SERVER-------------------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.eks_workers_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.eks_workers_sg.id
  referenced_security_group_id = var.eks_cluster_sg
  description       = "Allow communication from control plane to worker nodes"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_trafic" {
  security_group_id = aws_security_group.eks_workers_sg.id
  referenced_security_group_id = var.eks_cluster_sg
  description       = "Allow communication from control plane to worker nodes"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.eks_workers_sg.id
  description       = "Allow worker nodes to communicate with each other"
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

# CREATING OUTBOUND SECURITY GROUP FOR JUPITER SERVER-------------------------------------------------------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.eks_workers_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}