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
  --region us-east-1 \
  --cluster my-eks-cluster \
  --approve

# 2️⃣ Download and create IAM policy
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam-policy.json

# 3️⃣ Create IAM Role for the controller using eksctl
eksctl create iamserviceaccount \
  --cluster my-eks-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::450665609241:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --override-existing-serviceaccounts

# 4️⃣ Add the EKS chart repo
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# 5️⃣ Install the controller using Helm
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-eks-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-0e7e054a6567e7a7d \
  --set image.tag="v2.6.2"

# ✅ Verify Installation
kubectl get deployment -n kube-system aws-load-balancer-controller

# Troubleshooting
kubectl -n kube-system describe deployment aws-load-balancer-controller
kubectl -n kube-system get rs | grep aws-load-balancer-controller
kubectl -n kube-system describe rs aws-load-balancer-controller-5b9c79656

✅ Fix: Create the Required IAM-Backed Service Account
Run the following eksctl command to create the aws-load-balancer-controller service account with the correct IAM policy:

eksctl create iamserviceaccount \
  --cluster my-eks-cluster \
  --region us-east-1 \
  --name aws-load-balancer-controller \
  --namespace kube-system \
  --attach-policy-arn arn:aws:iam::450665609241:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --override-existing-serviceaccounts

# 🔄 Restart the Controller Deployment:
kubectl rollout restart deployment aws-load-balancer-controller -n kube-system


# Fix it Manually (Quickest Way)
kubectl create serviceaccount aws-load-balancer-controller -n kube-system

# Then patch it with the IAM role:
kubectl annotate serviceaccount aws-load-balancer-controller \
  -n kube-system \
  eks.amazonaws.com/role-arn=arn:aws:iam::450665609241:role/aws-load-balancer-controller/eksctl-my-eks-cluster-addon-iamserviceaccount-Role1-ABC123XYZ456 \
  --overwrite

# Remove webhook features
volumes:
  - name: cert
    secret:
      secretName: aws-load-balancer-tls

