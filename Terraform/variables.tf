variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Region for GKE"
  default     = "asia-northeast1"
}

variable "zone" {
  type        = string
  description = "Zone for GKE nodes"
  default     = "asia-northeast1-b"
}

variable "network_name" {
  type    = string
  default = "gke-gitops-vpc"
}

variable "subnet_name" {
  type    = string
  default = "gke-gitops-subnet"
}

variable "gke_cluster_name" {
  type    = string
  default = "gke-gitops-cluster"
}
