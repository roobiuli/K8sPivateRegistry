


resource "kubernetes_deployment" "privatedockerregistry" {
  metadata {
    name = "dockerregistry"

  }

  spec {
    replicas = "1"
    selector {
      match_labels = {
        app = "dockerregistry"
      }
    }
    template {
      metadata {
        labels = {
          app = "dockerregistry"
        }
      }
      spec {
        // Directory Host Volumes so no claims on a PV
        volume {
          name = "certs-vol"
          host_path {
            path = "/opt/certs"
            type = "Directory"
          }
        }
        volume {
          name = "registry-vol"
          host_path {
            path = "/opt/registry"
            type = "Directory"
          }
        }
        container {
          image = "registry:2"
          name = "private-repository-k8s"
          image_pull_policy = "IfNotPresent"
          env {
            name = "REGISTRY_HTTP_TLS_CERTIFICATE"
            value = "/certs/registry.crt"
          }
          env {
            name = "REGISTRY_HTTP_TLS_KEY"
            value = "/certs/registry.key"
          }
          port {
            container_port = 5000
          }
          volume_mount {
            mount_path = "/certs"
            name = "certs-vol"
          }
          volume_mount {
            mount_path = "/var/lib/registry"
            name = "registry-vol"
          }
        }
      }
    }
  }
}
