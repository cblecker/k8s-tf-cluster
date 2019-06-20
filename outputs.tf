output "project" {
  value       = var.project
  description = "The GCP project ID."
}

output "cluster_name" {
  value       = var.cluster_name
  description = "GKE cluster name."
}

output "cluster_region" {
  value       = var.region
  description = "The GKE cluster region."
}
