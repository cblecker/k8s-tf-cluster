/*
This file defines the k8s services GKE cluster
*/

resource "google_container_cluster" "cluster" {
  provider = google-beta

  name               = var.cluster_name
  project            = data.google_project.project.id
  location           = data.google_container_engine_versions.us-central1.location
  min_master_version = data.google_container_engine_versions.us-central1.latest_master_version

  // Start with a single node, because we're going to delete the default pool
  initial_node_count = 1

  // Removes the default node pool, so we can custom create them as separate
  // objects
  remove_default_node_pool = true

  // Disable local and certificate auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  // Enable Stackdriver Kubernetes Monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  // Set maintenance time to 03:00 PST
  maintenance_policy {
    daily_maintenance_window {
      start_time = "11:00"
    }
  }

  // Restrict master to Google IP space; use Cloud Shell to access
  master_authorized_networks_config {
  }

  // GKE clusters are critical objects and should not be destroyed
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_container_node_pool" "pool-1" {
  provider = google-beta

  name_prefix = "pool-1-"
  project     = data.google_project.project.id
  location    = google_container_cluster.cluster.location
  cluster     = google_container_cluster.cluster.name

  // Start with a single node
  initial_node_count = 1

  // Auto repair, and auto upgrade nodes to match the master version
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  // Autoscale the cluster as needed. Note that these values will be multiplied
  // by 3, as the cluster will exist in three zones
  autoscaling {
    min_node_count = 1
    max_node_count = 20
  }

  // Set machine type, and standard oauth scopes
  node_config {
    machine_type = "n1-standard-4"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  // If we need to destroy the node pool, create the new one before destroying
  // the old one
  lifecycle {
    create_before_destroy = true
  }

  // Set longer timeouts, as provisioning a node pool can take a while
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
