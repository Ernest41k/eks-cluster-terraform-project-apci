# INSTALLING AWS LOAD BALANCER CONTROLLER 
# ✅ Prerequisites
- kubectl and eksctl installed
- IAM OIDC provider associated with your cluster
- IAM permissions to create roles, policies, and attach to the cluster
- Helm installed (v3+)
- You’re using EKS version ≥ 1.19

# 🔧 Step-by-Step Installation
# 1️⃣ Associate OIDC provider with your cluster (RUN USING GIT BASH)
eksctl utils associate-iam-oidc-provider \
  --region <your-region> \
  --cluster <your-cluster-name> \
  --approve

# 2️⃣ Download and create IAM policy
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam-policy.json

# 3️⃣ Create IAM Role for the controller using eksctl
eksctl create iamserviceaccount \
  --cluster <your-cluster-name> \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<your-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --override-existing-serviceaccounts

# 4️⃣ Add the EKS chart repo
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# 5️⃣ Install the controller using Helm
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<your-region> \
  --set vpcId=<your-vpc-id> \
  --set image.tag="v2.6.2"

# ✅ Verify Installation
kubectl get deployment -n kube-system aws-load-balancer-controller

