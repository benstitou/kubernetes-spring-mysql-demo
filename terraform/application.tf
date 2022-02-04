resource "kubernetes_service" "demo_app_spring_service" {
  metadata {
    name      = "demo-app-spring"
    namespace = kubernetes_namespace.demo_app_ns.metadata.0.name
    labels = {
      app = "demo-app-spring"
    }
  }

  spec {
    type = "LoadBalancer"
    selector = {
      app = "demo-app-spring"
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
      node_port   = 30000
    }
  }
}


resource "kubernetes_deployment" "demo_app_spring_deployment" {
  metadata {
    name      = "demo-app-spring"
    namespace = kubernetes_namespace.demo_app_ns.metadata.0.name
    labels = {
      app = "demo-app-spring"
    }
  }


  spec {
    selector {
      match_labels = {
        app = "demo-app-spring"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo-app-spring"
        }
      }

      spec {
        container {
          name              = "demo-app-spring"
          image             = "<YOUR_DOCKER_USERNAME>/k8s-terraform-spring-mysql:latest"
          image_pull_policy = "IfNotPresent"

          port {
            name           = "http"
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = 0.2
              memory = "200Mi"
            }
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "mysql-user-password"
                name = kubernetes_secret.demo_app_secret.metadata.0.name

              }
            }
          }

          env {
            name = "DB_SERVER"
            value_from {
              config_map_key_ref {
                key  = "mysql-server"
                name = kubernetes_config_map.demo_app_cm.metadata.0.name
              }
            }
          }

          env {
            name = "DB_NAME"
            value_from {
              config_map_key_ref {
                key  = "mysql-database-name"
                name = kubernetes_config_map.demo_app_cm.metadata.0.name
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
        }
        image_pull_secrets {
          name = kubernetes_secret.demo_app_secret.metadata.0.name
        }
      }
    }
  }
}
