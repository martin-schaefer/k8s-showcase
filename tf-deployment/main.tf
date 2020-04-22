# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Terraform deployment for k8s-showcasw
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  required_version = ">= 0.12"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The Kubernetes provider
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "kubernetes" {
  config_context = var.kubectl_config_context_name
  config_path    = var.kubectl_config_path
}

resource "kubernetes_deployment" "k8s-be" {
  metadata {
    name = "k8s-be"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "k8s-be"
      }
    }
    template {
      metadata {
        labels = {
          app = "k8s-be"
          fluentd-log-format = "spring-boot-json"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/path" = "/actuator/prometheus"
          "prometheus.io/port" = "8010"
        }
      }
      spec {
        container {
          name  = "k8s-be-container"
          image = "gcr.io/handy-zephyr-272321/k8s-be:latest"
          port {
            name = "service-port"
            container_port = 80
          }
          port {
            name = "management-port"
            container_port = 8010
          }
          readiness_probe {
            http_get {
              path = "/actuator/health"
              port = 8010
            }
            timeout_seconds = 5
            period_seconds = 30
            success_threshold = 1
            failure_threshold = 1
          }
        }
      }
    }
  }
}
