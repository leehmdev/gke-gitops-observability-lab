# VPC
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Regional GKE Cluster in asia-northeast1
resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.region # asia-northeast1 

  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  # Remove default nodepool (seperatly manage the node_pool)
  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  # Pod / Service CIDR auto provisioning
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/20"
  }

  # Node zones
  node_locations = [var.zone]
}

# Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.gke_cluster_name}-np"
  location = var.region
  cluster  = google_container_cluster.primary.name

  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-standard-4"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      role = "app"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
