/*
This file defines the data sources for the GCP project
*/

data "google_project" "project" {
  project_id = "${var.project}"
}

data "google_project_services" "project" {
  project = "${data.google_project.project.id}"
}
