# GKE GitOps + Observability Lab

This repository demonstrates a practical GitOps-based Kubernetes deployment on Google Kubernetes Engine (GKE), combined with full observability using Prometheus and Grafana.

The goal of this project is to showcase a clean and reproducible cloud-native workflow using industry-standard tools.

---

## 🛠 Technologies Used

- **Google Kubernetes Engine (GKE)**
- **Terraform**
- **Helm**
- **Argo CD (GitOps)**
- **Prometheus**
- **Grafana**
- **NGINX Sample API**
- **GitHub (GitOps repository)**

---

## 🏗 Architecture Overview

```text
GitHub (main branch)
│
▼
Argo CD
│
▼
GKE Cluster (asia-northeast1-b)
│
├── sample-api (NGINX)
└── Monitoring (Prometheus + Grafana)
```

---

## 📂 Repository Structure

```text
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
```

---

## 🚀 Deployment Flow

### 1️⃣ Infrastructure Provisioning (Terraform)

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2️⃣ Monitoring Stack Installation (Helm)

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
```

### 3️⃣ Sample Application Deployment (Helm)

```bash
kubectl create namespace apps

cd apps/sample-api
helm install sample-api . -n apps
```

### 4️⃣ GitOps Deployment (Argo CD)

```bash
kubectl apply -n argocd -f argocd/sample-api-app.yaml
```

Argo CD will continuously monitor this GitHub repository and automatically sync changes to the GKE cluster.

---

## 📊 Observability

Grafana is exposed via port-forward:

```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

Access at:

```
http://localhost:3000
```

Default user:

```
admin
```

Get the password:

```bash
kubectl get secret --namespace monitoring prometheus-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

---

## ✅ Key Features

- GitOps-based workload deployment
- Real-time observability (metrics & dashboards)
- Infrastructure as code with Terraform
- Modular and production-like structure
- Easy scalability via Git push

---

This project is intended as a reference architecture for cloud-native Kubernetes environments.
