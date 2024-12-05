# main.tf

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.31.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }
  }
}

provider "linode" {
  token = var.linode_api_token
}

# Generate a random name for the Kubernetes cluster
resource "random_pet" "cluster_name" {
  length    = 2
  separator = "-"
}

# Define the Kubernetes Cluster
resource "linode_lke_cluster" "k8s_cluster" {
  label        = random_pet.cluster_name.id
  region       = "us-east"       # US, Atlanta, GA
  k8s_version  = "1.31"          # Kubernetes version

  node_pools = [{
    type     = "g6-standard-4"   # Adjust based on Linode's available types
    count    = 3                # Number of nodes
    label    = "default-pool"
    tags     = ["k8s-node"]
  }]
}

# Outputs
output "k8s_cluster_id" {
  description = "The ID of the Kubernetes cluster"
  value       = linode_lke_cluster.k8s_cluster.id
}

output "kubeconfig" {
  description = "Kubeconfig to access the Kubernetes cluster"
  value       = linode_lke_cluster.k8s_cluster.kubeconfig[0].raw_config
}
