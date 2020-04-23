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

module "k8s-be" {
  source = "./spring-boot-app"
  app_name = "k8s-be"
  node_port = 30001
}

module "k8s-bff" {
  source = "./spring-boot-app"
  app_name = "k8s-bff"
  node_port = 30002
}
