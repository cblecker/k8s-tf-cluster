/*
This file defines the provider versions, as well as the storage backend
*/

provider "google" {
  version = "~> 1.19"
}

provider "google-beta" {
  version = "~> 1.19"
}

terraform {
  backend "gcs" {
    bucket = "k8s-tf-state"
    prefix = "cluster/state"
  }
}
