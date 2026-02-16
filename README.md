# 🚀 Azure AKS WordPress Deployment with Automated CI/CD & Monitoring

This project demonstrates a professional, end-to-end DevOps lifecycle on Microsoft Azure. It features an automated pipeline that builds, pushes, and deploys a custom WordPress application onto a managed Kubernetes cluster (AKS), with a pre-configured monitoring stack.

## 🏗 System Architecture
The architecture is designed for scalability and high availability:

- **CI/CD Layer:** GitHub Actions & Terraform  
- **Cloud Infrastructure:** Azure Resource Group, VNet, ACR, and AKS  
- **Application Layer:** Custom WordPress Pods  
- **Observability:** Prometheus & Grafana  

![Project Architecture](digram1.jpg)  
*(Note: Ensure your diagram image is named `architecture-diagram.png` and placed in the root folder)*

---

## 🛠 Tech Stack

- **Cloud:** Microsoft Azure ☁️  
- **IaC:** Terraform 🏗️  
- **Orchestration:** AKS ☸️  
- **Registry:** ACR 🐳  
- **CI/CD:** GitHub Actions 🤖  

---

## 🚀 Deployment Guide

### 1️⃣ Provision Infrastructure

```powershell
cd terraform-infra
terraform init
terraform apply --auto-approve
```

Creates the cluster, registry, and networking components.

---

### 2️⃣ Connect AKS to ACR

Grant the cluster permission to pull your private Docker images:

```powershell
az aks update `
  --name "wp-aks-cluster" `
  --resource-group "wp-final-project-rg" `
  --attach-acr "wpacr2026ultimate"
```

---

### 3️⃣ Automated CI/CD

The pipeline is triggered on every git push. It handles:

- Building the Docker image  
- Pushing to Azure Container Registry  
- Rolling update on the AKS cluster  

---

## 📊 Monitoring & Observability

The repository includes configuration files for a full monitoring stack in the `/monitoring` directory:

- **Prometheus:** Configured to scrape metrics from the WordPress service  
- **Grafana:** Visualizes cluster health and resource consumption  

---

## 🔍 Verification

Confirm the deployment status and get the live External IP:

```powershell
kubectl get pods
kubectl get svc wordpress-service
```

---

## 🧹 Cleanup

To destroy all provisioned resources and stop billing:

```powershell
terraform destroy --auto-approve
```
