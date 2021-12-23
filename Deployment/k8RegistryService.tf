
resource "kubernetes_service" "dockerregistry" {
  metadata {
    name = "docker-private-registry-service"
  }
  spec {
    port {
      port = 5000
      node_port = 31320
      protocol = "TCP"
      target_port = 5000
    }
    selector = {
      app = kubernetes_deployment.privatedockerregistry.spec[0].selector[0].match_labels.app
    }
    type = "NodePort"
  }
}