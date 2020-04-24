# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Terraform deployment for k8s-showcase
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  required_version = ">= 0.12"
}

provider "kubernetes" {
  config_context = var.kubectl_config_context_name
  config_path    = var.kubectl_config_path
}

variable "app_namespace" {
  type = string
  default = "k8s-spring-boot-apps"
}

# The application namespace
resource "kubernetes_namespace" "app-namespace" {
  metadata {
    name = var.app_namespace
  }
}

# The default account in the application namespace must have read permissions
resource "kubernetes_cluster_role_binding" "cluster-admin-binding" {
  metadata {
    name = "app-namespace-default-cluster-admin"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = var.app_namespace
  }
}

# The Spring Boot applications
module "k8s-be" {
  source = "./spring-boot-app"
  app_name = "k8s-be"
  app_namespace = var.app_namespace
  node_port = 30001
}

module "k8s-bff" {
  source = "./spring-boot-app"
  app_name = "k8s-bff"
  app_namespace = var.app_namespace
  node_port = 30002
}
