output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_location" {
  value = google_container_cluster.primary.location
}

output "gke_endpoint" {
  value = google_container_cluster.primary.endpoint
}