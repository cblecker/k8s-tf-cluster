/*
This file defines the data sources for the GCP project
*/

data "google_project" "project" {
  // should match the name of the terraform workspace
  project_id = "k8s-infra-dev-cluster-turnup"
}

data "google_container_engine_versions" "us-central1" {
  project        = data.google_project.project.id
  location       = "us-central1"
  version_prefix = "1.13."
}
