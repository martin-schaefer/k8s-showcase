variable "namespace" {
  type = string
}

variable "name" {
  type = string
  default = "elasticsearch"
}

variable "http-rest-port" {
  type = number
  default = 9200
}

variable "inter-node-port" {
  type = number
  default = 9300
}

variable "data_mount_path" {
  type = string
  default = "/usr/share/elasticsearch/data"
}

# Persistent volume
resource "kubernetes_persistent_volume" "dsp" {
  metadata {
    name = "dsp"
  }
  spec {
    capacity = {
      storage = "16G"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      host_path {
        path = "/data/dsp/"
      }
    }
  }
}

# The elasticsearch service
resource "kubernetes_service" "elasticsearch" {
  metadata {
    name = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }
  spec {
    cluster_ip = "None"
    selector = {
      app = var.name
    }
    port {
      name = "http-rest"
      port = var.http-rest-port
    }
    port {
      name = "inter-node"
      port = var.inter-node-port
    }
  }
}

resource "kubernetes_stateful_set" "elasticsearch" {
  metadata {
    name = "es-cluster"
    namespace = var.namespace
  }
  spec {
    service_name = var.name
    replicas = 2

    selector {
      match_labels = {
        app = var.name
      }
    }
    template {
      metadata {
        labels = {
          app = var.name
        }
      }
      spec {
        container {
          name = var.name
          image = "docker.elastic.co/elasticsearch/elasticsearch:7.2.0"
          resources {
            requests {
              cpu = "100m"
            }
            limits {
              cpu = "1000m"
            }
          }
          port {
            name = "http-rest"
            container_port = var.http-rest-port
            protocol = "TCP"
          }
          port {
            name = "inter-node"
            container_port = var.inter-node-port
            protocol = "TCP"
          }
          volume_mount {
            name = var.name
            mount_path = var.data_mount_path
          }
          env {
            name = "cluster.name"
            value = "k8s-logs"
          }
          env {
            name = "node.name"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "discovery.seed_hosts"
            value = "es-cluster-0.elasticsearch,es-cluster-1.elasticsearch"
          }
          env {
              name = "cluster.initial_master_nodes"
              value = "es-cluster-0,es-cluster-1"
            }
          env {
            name = "ES_JAVA_OPTS"
            value = "-Xms512m -Xmx512m"
          }
        }
        init_container {
          name = "fix-permissions"
          image = "busybox"
          command = ["sh", "-c", "chown -R 1000:1000 ${var.data_mount_path}"]
          security_context {
            privileged = true
          }
          volume_mount {
            name = var.name
            mount_path = var.data_mount_path
          }
        }
        init_container {
          name = "increase-vm-max-map"
          image = "busybox"
          command = ["sysctl", "-w", "vm.max_map_count=262144"]
          security_context {
            privileged = true
          }
        }
        init_container {
          name = "increase-fd-ulimit"
          image = "busybox"
          command = ["sh", "-c", "ulimit -n 65536"]
          security_context {
            privileged = true
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = var.name
        labels = {
          app = var.name
        }
      }
      spec {
        access_modes = [ "ReadWriteOnce" ]
        resources {
          requests = {
            storage = "8G"
          }
        }
      }
    }
  }
}
