resource "kubernetes_config_map" "demo_app_cm" {
  metadata {
    name = "mysql-config-map"
    namespace = kubernetes_namespace.demo_app_ns.metadata.0.name
  }

  data = {
    mysql-server        = "demo-app-mysql"
    mysql-database-name = "demoDb"
    mysql-user-username = "myUser"
  }
}
