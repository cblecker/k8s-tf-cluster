/*
This file defines the provider versions, as well as the storage backend
*/

provider "google" {
  version = "~> 2.8"
}

terraform {
  required_version = ">= 0.12"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "k8s-infra"

    workspaces {
      name = "k8s-infra-dev-cluster-turnup" // should match the gcp project name
    }
  }
}
