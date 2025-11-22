# gke-gitops-observability-lab

🚀 Production-style GitOps & Observability Lab on GKE  

A real-world architecture built with 
**Terraform, Helm, Argo CD, Prometheus, and Grafana.**

This repository is shared to document and demonstrate practical cloud-native patterns used in modern Kubernetes environments.

---

## 📌 Project Overview

This project provisions a Google Kubernetes Engine (GKE) cluster in **asia-northeast1-b** and implements a complete cloud-native workflow:

- Infrastructure as Code with Terraform
- Application deployment using Helm
- GitOps-based continuous delivery with Argo CD
- Full observability using Prometheus & Grafana
- GitHub as the Single Source of Truth

The purpose of this lab is to document a realistic, production-style environment for learning, experimentation, and knowledge sharing.

---

## 🛠 Technologies Used

- Google Kubernetes Engine (GKE)
- Terraform
- Helm
- Argo CD (GitOps)
- Prometheus
- Grafana
- NGINX Sample API
- GitHub (GitOps repository)

---

## 🗺 Architecture Overview

GitHub (main branch)
│
Argo CD
│
GKE Cluster (asia-northeast1-b)
│
├── sample-api (NGINX)
└── Monitoring (Prometheus + Grafana)

---

Repository Structure

gke-gitops-observability-lab/
│
├── terraform/                   # Terraform code to provision VPC + GKE
│
├── apps/
│   └── sample-api/               # Helm chart for NGINX application
│
├── argocd/
│   └── sample-api-app.yaml       # Argo CD Application manifest
│
├── docs/
│   └── screenshots/              # Grafana / Argo / Architecture screenshots
│
└── README.md


---

## 🚀 Deployment Flow

### 1) Infrastructure Provisioning (Terraform)

cd terraform

terraform init  
terraform plan  
terraform apply  

This creates:
- VPC + Subnets
- GKE Cluster
- Node Pools

---

### 2) Application Deployment (Helm)

kubectl create namespace apps

cd apps/sample-api  
helm install sample-api . -n apps  

Verify:

kubectl get pods -n apps  
kubectl get svc -n apps  

A LoadBalancer IP will expose the NGINX application.

---

### 3) Observability Stack (Prometheus + Grafana)

kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts  
helm repo update  

helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring  

Grafana access:

kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80  

URL:  
http://localhost:3000

Admin password:

kubectl -n monitoring get secret prometheus-grafana \
-o jsonpath="{.data.admin-password}" | base64 --decode

---

### 4) GitOps (Argo CD)

Install Argo CD:

kubectl create namespace argocd  

kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml  

Expose UI:

kubectl port-forward -n argocd svc/argocd-server 8080:443  

URL:  
https://localhost:8080

Apply application:

kubectl apply -f argocd/sample-api-app.yaml  

After this point, GitHub becomes the deployment controller and all changes are synchronized through Argo CD.

---

## 🔁 GitOps Sync Example

Edit this file:

apps/sample-api/values.yaml

Change:

replicaCount: 3

Push change:

git add apps/sample-api/values.yaml  
git commit -m "Increase sample-api replicas to 3"  
git push  

Result:

- Argo CD automatically syncs the change
- Pod count increases
- Grafana reflects new metrics
- GitOps workflow confirmed

---

## 📊 What You Can Monitor

In Grafana, typical dashboards include:

- Kubernetes / Pods
- Kubernetes / Namespace
- Kubernetes / Nodes
- CPU & Memory usage per workload
- Network traffic
- Application performance

This setup reflects a common real-world observability stack used in Kubernetes environments.

---

## 💡 Why This Project Exists

This repository was created to:

- Practice cloud-native architectural patterns
- Document real operational workflows
- Explore GitOps and observability concepts
- Share knowledge and reusable infrastructure patterns

It serves as a living lab and technical reference.

---

## 👤 Author

Hyunmyung Lee  
Cloud / Infrastructure Engineer  

GitHub: https://github.com/leehmdev
