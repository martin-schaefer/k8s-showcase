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

# A reader role for the application namespace
resource "kubernetes_role" "namespace-reader-role" {
  metadata {
    name = "namespace-reader"
    namespace = var.app_namespace
  }
  rule {
    api_groups = ["", "extensions", "apps"]
    resources = ["configmaps", "pods", "services", "endpoints", "secrets"]
    verbs = ["get", "list", "watch"]
  }
}

# The default account in the application namespace has the reader role
resource "kubernetes_role_binding" "namespace-reader-bindig" {
  metadata {
    name = "namespace-reader-binding"
    namespace = var.app_namespace
  }
  role_ref {
    kind      = "Role"
    name      = "namespace-reader"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    api_group = ""
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
