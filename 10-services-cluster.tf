/*
This file defines the k8s services GKE cluster
*/

locals {
  target_gke_version = "1.13.6-gke.6"
}

resource "google_container_cluster" "cluster" {
  name               = "k8s-services-cluster"
  project            = data.google_project.project.id
  location           = "us-central1"
  initial_node_count = 1
  min_master_version = local.target_gke_version

  // Disable local and certificate auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  // Enable or disable cluster features
  enable_kubernetes_alpha = false
  enable_legacy_abac      = false

  // Removes the default node pool, so we can custom create them as separate objects
  remove_default_node_pool = true

  // Enable Stackdriver Kubernetes Monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  // Set maintenance time to 03:00 PT
  maintenance_policy {
    daily_maintenance_window {
      start_time = "11:00"
    }
  }

  // Restrict master to Google IP space; use Cloud Shell to access
  master_authorized_networks_config {
  }

  // GKE clusters are critical objects and should not be destroyed.
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_container_node_pool" "pool-1" {
  name_prefix = "pool-1-"
  project     = data.google_project.project.id
  location    = google_container_cluster.cluster.location
  cluster     = google_container_cluster.cluster.name

  initial_node_count = 1
  version            = local.target_gke_version

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 20
  }

  node_config {
    machine_type = "n1-standard-8"
    oauth_scopes = ["compute-rw", "storage-ro", "logging-write", "monitoring"]
  }

  // If we need to destroy the node pool, create the new one before destroying
  // the old one.
  lifecycle {
    create_before_destroy = true
  }

  // Set longer timeouts
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
