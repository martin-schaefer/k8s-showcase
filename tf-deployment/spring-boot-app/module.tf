# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module for Spring Boot app standard deployment
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "app_name" {
  type = string
}

variable "app_namespace" {
  type = string
}

variable "node_port" {
  type = number
}

resource "kubernetes_config_map" "spring-boot-app-config-map" {
  metadata {
    name = var.app_name
    namespace = var.app_namespace
  }

  data = {
    "application.yml" = "${file("./app-config/${var.app_name}.yml")}"
  }
}

resource "kubernetes_deployment" "spring-boot-app-deployment" {
  metadata {
    name = var.app_name
    namespace = var.app_namespace
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_name
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
          name  = "${var.app_name}container"
          image = "gcr.io/handy-zephyr-272321/${var.app_name}:latest"
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

resource "kubernetes_service" "spring-boot-app-service" {
  metadata {
    name = var.app_name
    namespace = var.app_namespace
  }
  spec {
    selector = {
      app = var.app_name
    }
    port {
      port = 80
      node_port = var.node_port
    }
    type = "NodePort"
  }
}

resource "kubernetes_service" "spring-boot-app-management" {
  metadata {
    name = "${var.app_name}-management"
    namespace = var.app_namespace
  }
  spec {
    selector = {
      app = var.app_name
    }
    port {
      port = 8010
    }
  }
}
