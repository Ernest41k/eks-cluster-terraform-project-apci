# Connect to EKS cluster
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster

# For All IAM Users Access for the EKS Cluster
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster --profile ernest-eks-user

# Command to Switch Working Namespace
kubectl config set-context --current --namespace=dev
-----------------------------------------------------------------------------------------------------------
# LOCATING YOUR EKS CLUSTER CERTIFICATE AUTHORITY
aws eks describe-cluster --name my-eks-cluster --query "cluster.certificateAuthority.data" --output text
------------------------------------------------------------------------------------------------------------
# CREATING A USER For Your EKS Cluster

# STEP: 1 Create an IAM User with CLI Access
IAM user Created with access key and secret access keys --> "ernest-eks-user"
- Grant this User "Administrative" permission within AWS

# STEP: 2 Map the IAM User to your Kubernetes aws-auth ConfigMap
kubectl edit configmap aws-auth -n kube-system
-------------------------
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::450665609241:role/eks_worker_nodes_role1
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
# Add the line below to your configmap
  mapUsers: |
    - userarn: arn:aws:iam::450665609241:user/obiri-eks-user
      username: obiri
      groups:
        - dev
----------------------------
# STEP: 3 Set up the AWS CLI profile for ernest-eks-user
aws configure --profile ernest-eks-user
- Follow the instruction to complete 

# ADD RBAC FOR ERNEST USER
# 🛡️ 4. Create a Role to grant read access to pods in a namespace (if not already created)
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: dev-role
  namespace: dev
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]

# 🔗 5. Bind the Role to the dev Group
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-group-binding
  namespace: dev
subjects:
  - kind: Group
    name: dev
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: dev-role
  apiGroup: rbac.authorization.k8s.io

# Access the EKS Cluster as ernest-eks-user
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster --profile ernest-eks-user
-----------------------------------------------------------------------------------------------------------




