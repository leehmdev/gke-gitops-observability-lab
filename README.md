# GKE GitOps + Observability Lab

This repository demonstrates a practical **GitOps-based Kubernetes deployment on Google Kubernetes Engine (GKE)**, combined with full **observability using Prometheus and Grafana**.

It represents a clean, production-style setup using industry-standard tools and workflows.

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

This creates:
- VPC + Subnet
- GKE Cluster in `asia-northeast1-b`
- Required IAM / networking components

---

### 2️⃣ Monitoring Stack Installation (Helm)

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
```

Verify:

```bash
kubectl get pods -n monitoring
```

---

### 3️⃣ Sample Application Deployment (Helm)

```bash
kubectl create namespace apps

cd apps/sample-api
helm install sample-api . -n apps
```

Verify:

```bash
kubectl get pods -n apps
kubectl get svc -n apps
```

You should see an **external IP** attached to the `sample-api` service.

---

## 🔄 GitOps Deployment (Argo CD)

### Apply the Argo CD application

```bash
kubectl apply -n argocd -f argocd/sample-api-app.yaml
```

Argo CD will now:
- Monitor this GitHub repository
- Compare desired state vs actual state
- Automatically sync Kubernetes resources

---

## 🌐 Argo CD Web UI Access

### Start port-forwarding

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then open in browser:

```
http://localhost:8080
```

### Login details

Default username:

```text
admin
```

Get the initial password:

```bash
kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath="{.data.password}" | base64 --decode ; echo
```

After login, you should see:

- ✅ Application: `sample-api`
- ✅ Status: **Synced**
- ✅ Health: **Healthy**
- ✅ Source: GitHub repository
- ✅ Target: `apps` namespace in GKE

---

## 📊 Grafana Web UI Access (Observability)

### Start port-forwarding

```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

Open in browser:

```text
http://localhost:3000
```

Username:

```text
admin
```

Get the password:

```bash
kubectl get secret --namespace monitoring prometheus-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Available dashboards:
- Kubernetes / Cluster
- Pods / Nodes / Workloads
- CoreDNS & Networking
- etcd, kubelet, API server

---

## ✅ How to Validate GitOps is Working

1) Edit this file in GitHub:

```
apps/sample-api/values.yaml
```

Example change:

```yaml
replicaCount: 3
```

2) Commit & Push to GitHub

```bash
git add apps/sample-api/values.yaml
git commit -m "Increase replicas to 3"
git push
```

3) In Argo CD Web UI:
- Click **Refresh**
- Then **Sync**

4) Verify:

```bash
kubectl get pods -n apps
```

✅ You should now see **3 pods running**

This confirms:
- GitHub → Argo CD → GKE is fully working ✅

---

## ✅ Key Features

- Real GitOps workflow using Argo CD
- Infrastructure as Code with Terraform
- Helm-based application deployment
- Full observability (Prometheus + Grafana)
- Reproducible & scalable architecture
- Production-style structure

---

This repository is intended as a reference, learning resource, and example of best practices for GitOps-based Kubernetes operations on GCP.
