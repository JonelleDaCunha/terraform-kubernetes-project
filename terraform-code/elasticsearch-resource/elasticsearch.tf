
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.16.0"
    }
  }
}
# variable "cluster_ready_dependency" {
#   # the value doesn't matter; we're just using this variable
#   # to propagate dependencies.
#   type    = any
#   default = []
# }
# data "digitalocean_kubernetes_cluster" "k8s-cluster" {
#    depends_on = [var.cluster_ready_dependency]
#   name = "k8s-terraform-assignment"
# }

# variable "cluster_data" {
#   # the value doesn't matter; we're just using this variable
#   # to propagate dependencies.
#   type    = any
#   default = []
# }



#Deploy ES with helm chart template
resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.15.0"
  timeout    = 900

  set {
    name  = "volumeClaimTemplate.storageClassName"
    value = "do-block-storage"
  }

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = "5Gi"
  }

  set {
    name  = "imageTag"
    value = "7.15.0"
  }

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "exposeHttp"
    value = "true"
  }

  # set {
  #   name  = "securityContext.enabled"
  #   value = "true"
  # }
  # set {
  #   name  = "discovery.type"
  #   value = "single-node"
  # }
}