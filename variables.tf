variable "cluster_name" {
  default     = "cncf-cluster"
  description = "The GKE cluster name."
}

variable "project" {
  type        = string
  description = "Project to use."
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region to create resources in. See https://cloud.google.com/compute/docs/regions-zones/ for valid values."
}
