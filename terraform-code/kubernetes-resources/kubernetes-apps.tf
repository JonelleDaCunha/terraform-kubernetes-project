
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



#Deploy Node.js app that return cluster health status
resource "kubernetes_deployment" "es-status-api-deployment" {
  metadata {
    name = "es-status-api"
    labels = {
      app = "es-status-api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "es-status-api"
      }
    }

    strategy {
      rolling_update {
        max_surge = 0
        max_unavailable = 1
      }

    }
    template {
      metadata {
        labels = {
          app = "es-status-api"
        }
      }

      spec {
        
        container {
          image = "jonelledacunha/elasticsearch-status-api:v5"
          name  = "es-status-api"
          port {
            container_port = 3000
            host_port      = 3000
          }
          env {
            name  = "ES_HOST"
            value = "elasticsearch-master"
          }
          env {
            name  = "ES_PORT"
            value = "9200"
          }
        }
      }
    }
  }
}
