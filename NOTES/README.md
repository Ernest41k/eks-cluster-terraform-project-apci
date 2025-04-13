# Create the IAM policy in Terraform
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam-alb-controller-policy.json")
}

✅ That’s it!
Once you apply this:
You’ll have a fully working, AWS-approved IAM policy named AWSLoadBalancerControllerIAMPolicy in your account.

You can then attach it to:

# Command to Connect to the cluster
aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster

-----------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

# Create the IAM policy in Terraform
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam-alb-controller-policy.json")
}
--------------------------------------------------------------------------