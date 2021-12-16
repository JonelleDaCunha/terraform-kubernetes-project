terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.16.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

provider "helm" {
  kubernetes {
    token = data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].token
    host  = data.digitalocean_kubernetes_cluster.k8s-cluster.endpoint
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].cluster_ca_certificate
    )
    client_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].client_certificate
    )
    client_key = base64decode(
      data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].client_key
    )
  }
}

provider "kubernetes" {
  token = data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].token
  host  = data.digitalocean_kubernetes_cluster.k8s-cluster.endpoint
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].cluster_ca_certificate
  )

  client_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].client_certificate
  )
  client_key = base64decode(
    data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].client_key
  )
}

# Create a digitalocean kubernetes cluster
resource "digitalocean_kubernetes_cluster" "k8s-terraform-assignment" {
  name   = "k8s-terraform-assignment"
  region = "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.21.5-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    node_count = 1

  }
}

data "digitalocean_kubernetes_cluster" "k8s-cluster" {
  depends_on = [digitalocean_kubernetes_cluster.k8s-terraform-assignment]
  name       = "k8s-terraform-assignment"
}

#Create a digitalocean volume
# resource "digitalocean_volume" "cluster_volume" {
#   region                  = "nyc1"
#   name                    = "cluster-volume"
#   size                    = 30
#   initial_filesystem_type = "ext4"
#   description             = "VOlume for the Kubernetes clustee"
# }

#Attach volume to cluster
# resource "digitalocean_volume_attachment" "volume-attachment" {
#   droplet_id = digitalocean_kubernetes_cluster.k8s-terraform-assignment.id
#   volume_id  = digitalocean_volume.cluster_volume.id
# }

module "elasticsearch-cluster" {
  source       = "./elasticsearch-resource"
#   cluster_data = data.digitalocean_kubernetes_cluster.k8s-cluster
  # cluster_ready_dependency = [digitalocean_kubernetes_cluster.k8s-terraform-assignment]

  # providers = {
  #     digitalocean = digitalocean
  # }
}

module "kubernetes" {
  source       = "./kubernetes-resources"
#   cluster_data = data.digitalocean_kubernetes_cluster.k8s-cluster
  depends_on = [
    module.elasticsearch-cluster
  ]

  # cluster_ready_dependency = [digitalocean_kubernetes_cluster.k8s-terraform-assignment, module.elasticsearch-cluster]
  # providers = {
  #     digitalocean = digitalocean
  # }
}