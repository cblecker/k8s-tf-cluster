/*
This file defines the data sources for the GCP project
*/

data "google_project" "project" {
  project_id = "k8s-infra-dev-cluster-turnup"
}
