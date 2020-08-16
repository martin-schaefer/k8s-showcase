# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Terraform deployment for k8s-showcase
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.12.0"
    }
  }
  required_version = ">= 0.13"
}

provider "kubernetes" {
  config_context = var.kubectl_config_context_name
  config_path    = var.kubectl_config_path
}

variable "app_namespace" {
  type    = string
  default = "k8s-spring-boot-apps"
}

variable "version_k8s-be" {
  type = string
}

variable "version_k8s-bff" {
  type = string
}

variable "version_k8s-sba" {
  type = string
}

variable "logging_namespace" {
  type    = string
  default = "k8s-logging"
}

# The application namespace
resource "kubernetes_namespace" "app-namespace" {
  metadata {
    name = var.app_namespace
  }
}

# The logging namespace
resource "kubernetes_namespace" "logging-namespace" {
  metadata {
    name = var.logging_namespace
  }
}

# A reader role for the application namespace
resource "kubernetes_role" "namespace-reader-role" {
  metadata {
    name      = "namespace-reader"
    namespace = var.app_namespace
  }
  rule {
    api_groups = ["", "extensions", "apps"]
    resources  = ["namespaces", "configmaps", "pods", "services", "endpoints", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
}

# The default account in the application namespace has the reader role
resource "kubernetes_role_binding" "namespace-reader-bindig" {
  metadata {
    name      = "namespace-reader-binding"
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
    namespace = var.app_namespace
    api_group = ""
  }
}

module "imago" {
  source          = "./imago"
  namespace = var.app_namespace
  schedule  = "* * * * *"
}

module "elasticsearch" {
  source          = "./elasticsearch"
  namespace = var.logging_namespace
}

# The Spring Boot applications
module "k8s-be" {
  source        = "./spring-boot-app"
  app_name      = "k8s-be"
  app_version   = var.version_k8s-be
  app_namespace = var.app_namespace
  app_replicas  = 2
  node_port     = 30001
}

module "k8s-bff" {
  source        = "./spring-boot-app"
  app_name      = "k8s-bff"
  app_version   = var.version_k8s-bff
  app_namespace = var.app_namespace
  app_replicas  = 2
  node_port     = 30002
}

module "k8s-sba" {
  source        = "./spring-boot-app"
  app_name      = "k8s-sba"
  app_version   = var.version_k8s-sba
  app_namespace = var.app_namespace
  node_port     = 30003
}
