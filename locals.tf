locals {
  project_tags = {
    contact      = "devops@apci.com"
    application  = "Jupiter"
    project      = "APCI"
    "kubernetes.io/role/elb" = "1" # Kubernetes controllers (like the AWS Load Balancer Controller) scan for resources with this tag to ensure they are managed as part of the cluster
    "kubernetes.io/cluster/my-eks-cluster" = "shared" # This tag links the resource (e.g., a load balancer or other AWS resources) to a specific Kubernetes cluster (my-eks-cluster in this case).
    environment  = "${terraform.workspace}" # refers to your current workspace (dev, prod, etc)
    creationTime = timestamp()
  }
}