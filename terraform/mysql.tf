resource "kubernetes_service" "demo_app_mysql_service" {
  metadata {
    name      = "demo-app-mysql"
    namespace = kubernetes_namespace.demo_app_ns.metadata.0.name
    labels = {
      app = "demo-app"
    }
  }

  spec {
    selector = {
      app  = kubernetes_deployment.demo_app_mysql_deployment.metadata.0.labels.app
      tier = "mysql"
    }

    port {
      port = 3306
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_persistent_volume_claim" "demo_app_pvc" {
  metadata {
    name      = "mysql-pvc"
    namespace = kubernetes_namespace.demo_app_ns.metadata.0.name
    labels = {
      app = "demo-app"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "demo_app_mysql_deployment" {
  metadata {
    name      = "demo-app-mysql"
    namespace = kubernetes_namespace.demo_app_ns.metadata.0.name
    labels = {
      app = "demo-app"
    }
  }

  spec {
    selector {
      match_labels = {
        app  = "demo-app"
        tier = "mysql"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          app  = "demo-app"
          tier = "mysql"
        }
      }

      spec {
        container {
          image = "mysql:5.6"
          name  = "mysql"

          env {
            name = "MYSQL_DATABASE"
            value_from {
              config_map_key_ref {
                key  = "mysql-database-name"
                name = kubernetes_config_map.demo_app_cm.metadata.0.name

              }
            }
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "mysql-root-password"
                name = kubernetes_secret.demo_app_secret.metadata.0.name

              }
            }
          }

          env {
            name = "MYSQL_USER"
            value_from {
              config_map_key_ref {
                key  = "mysql-user-username"
                name = kubernetes_config_map.demo_app_cm.metadata.0.name

              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "mysql-user-password"
                name = kubernetes_secret.demo_app_secret.metadata.0.name

              }
            }
          }

          liveness_probe {
            tcp_socket {
              port = 3306
            }
          }

          port {
            name           = "mysql"
            container_port = 3306
          }

          volume_mount {
            name       = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mysql-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.demo_app_pvc.metadata.0.name
          }
        }
      }
    }
  }
}

