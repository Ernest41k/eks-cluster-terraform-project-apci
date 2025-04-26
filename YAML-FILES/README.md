# These examples build your understanding from simple Pods to advanced storage and secrets usage
1. Pod Definition
     - pod-definition.yaml
     - pod-definition-loadbalancer.yaml

2. Deployment
    - deployment.yaml
    
3. Service (ClusterIP)
4. ConfigMap
5. Pod Using ConfigMap
6. Secret
7. Pod Using Secret
8. PersistentVolume
9. PersistentVolumeClaim
10. Pod with PVC Mounted

# Command to Connect to the cluster
aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster

# Command to Switch Working Namespace
kubectl config set-context --current --namespace=dev

# Command to list Pods in all namespaces
kubectl get pods --all-namespaces

# Command to Create objects in Kubernetes
kubectl create -f /path/to/yaml/file



=====================================================================================

🚀 Kubernetes Commands & Their Meaning
📌 Cluster Info:

- kubectl cluster-info
Shows details about your Kubernetes cluster (API server URL, DNS, etc.)

🧱 Namespace Management
- kubectl get namespaces
Lists all namespaces in the cluster.

- kubectl create namespace dev
Creates a new namespace called dev.

- kubectl delete namespace dev
Deletes the dev namespace and all its resources.

📦 Pods
- kubectl get pods
Lists all Pods in the default namespace.

- kubectl get pods -n dev
Lists Pods in the dev namespace.

- kubectl describe pod <pod-name>
Shows detailed information about a specific Pod.

kubectl delete pod <pod-name>

Deletes a specific Pod.

kubectl logs <pod-name>

Shows logs of a container in the Pod.

kubectl exec -it <pod-name> -- sh

Enters an interactive shell inside the container.

🔄 Deployments
kubectl get deployments

Lists all Deployments in the current namespace.

kubectl apply -f deployment.yaml

Applies the configuration defined in a YAML file.

kubectl delete -f deployment.yaml

Deletes the resources defined in the YAML file.

kubectl rollout restart deployment <name>

Restarts all Pods in the Deployment (useful after config changes).

kubectl scale deployment <name> --replicas=3

Scales the Deployment to 3 replicas (Pods).

🛠️ Services
kubectl get svc

Lists all Services in the current namespace.

kubectl describe svc <service-name>

Shows detailed info about the Service (ports, endpoints, etc.)

⚙️ ConfigMaps and Secrets
kubectl get configmaps

Lists all ConfigMaps.

kubectl describe configmap <name>

Shows the contents of a ConfigMap.

kubectl get secrets

Lists all Secrets.

kubectl describe secret <name>

Shows encoded Secret data and metadata.

🗂️ Storage
kubectl get pv

Lists all PersistentVolumes (cluster-wide).

kubectl get pvc

Lists PersistentVolumeClaims in the current namespace.

kubectl describe pvc <name>

Shows detailed info about a PVC (status, bound volume, etc.)

📥 Apply and Manage YAML Files
kubectl apply -f <file.yaml>

Creates or updates resources from a YAML file.

kubectl delete -f <file.yaml>

Deletes resources defined in the YAML file.

kubectl get all -n dev

Lists all resources in the dev namespace (Pods, Services, Deployments, etc.)

🎯 Bonus: Quick Cluster Status
kubectl get nodes

Lists all nodes in the cluster.

kubectl describe node <node-name>

Details of a specific node (e.g., capacity, taints, etc.)

