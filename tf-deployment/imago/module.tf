variable "namespace" {
  type = string
}

variable "name" {
  type = string
  default = "imago"
}

variable "schedule" {
  type = string
}

# A special role for imago with read & update permissions
resource "kubernetes_role" "imago" {
  metadata {
    name = var.name
    namespace = var.namespace
  }
  rule {
    api_groups = ["", "apps"]
    resources = ["pods", "replicasets", "statefulsets"]
    verbs = ["get", "list"]
  }
  rule {
    api_groups = ["", "batch"]
    resources = ["cronjobs"]
    verbs = ["get", "list", "update"]
  }
  rule {
    api_groups = ["", "apps"]
    resources = ["daemonsets", "deployments", "statefulsets"]
    verbs = ["get", "list", "update"]
  }
}

# The imago service account
resource "kubernetes_service_account" "imago" {
  metadata {
    name = var.name
    namespace = var.namespace
  }
}

# The imago service account has the imago role
resource "kubernetes_role_binding" "imago" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  role_ref {
    kind      = "Role"
    name      = var.name
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.name
    namespace = var.namespace
    api_group = ""
  }
}

# The imago cron job
resource "kubernetes_cron_job" "imago" {
  metadata {
    name = var.name
    namespace = var.namespace
  }
  spec {
    concurrency_policy = "Forbid"
    schedule = var.schedule
    job_template {
      metadata {}
      spec {
        template {
          metadata {
            labels = {
              app = var.name
            }
          }
          spec {
            restart_policy = "Never"
            service_account_name = var.name
            automount_service_account_token = true
            container {
              name = var.name
              image = "philpep/imago"
              args = ["--update"]
            }
          }
        }
      }
    }
  }
}
