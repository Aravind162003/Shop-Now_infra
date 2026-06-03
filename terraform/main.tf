# main.tf

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = "mern-gitops-project" 
  region  = "asia-south1"         
  zone    = "asia-south1-a"
}

# Create a GKE Standard Cluster
resource "google_container_cluster" "primary" {
  name     = "mern-cluster"
  location = "asia-south1-a"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

# Create a Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "mern-node-pool"
  location   = "asia-south1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    machine_type = "e2-medium" # 2 vCPUs, 4 GB RAM - Perfect for the free trial
    disk_size_gb = 20

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
