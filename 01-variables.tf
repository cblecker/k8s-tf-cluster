/*
This file defines variables that will be set for the entire Terraform configuration
*/

variable "region" {
  description = "The name of the Google Cloud region to provision resources in"
  default     = "us-central1"
}

variable "project" {
  description = "The name of the Google Cloud project to provision resources in"
}
