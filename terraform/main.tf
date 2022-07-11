resource "kubernetes_deployment" "golang" {
  metadata {
    name      = "golang"
    namespace = "golang"

    labels = {
      name = "golang"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "golang"
      }
    }

    template {
      metadata {
        labels = {
          name = "golang"
        }
      }

      spec {
        init_container {
          name    = "busybox"
          image   = "busybox:1.28"
          command = ["sh", "-c", "until nslookup golang-service.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for golang; sleep 2; done"]
        }

        container {
          name  = "golang"
          image = "golang"
          args  = ["/bin/sh", "-c", "touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600"]

          resources {
            limits = {
              cpu = "300m"

              memory = "500Mi"
            }

            requests = {
              cpu = "100m"

              memory = "500Mi"
            }
          }

          liveness_probe {
            exec {
              command = ["cat", "/tmp/healthy"]
            }

            initial_delay_seconds = 5
            period_seconds        = 5
          }

          readiness_probe {
            exec {
              command = ["cat", "/tmp/healthy"]
            }

            initial_delay_seconds = 5
            period_seconds        = 5
          }

          lifecycle {
            pre_stop {
              exec {
                command = ["/bin/sh", "-c", "golang -s quit; while killall -0 golang; do sleep 1; done"]
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    resource.kubernetes_namespace.golang
  ]
}

resource "kubernetes_service" "golang" {
  metadata {
    name = "golang"
  }

  spec {
    port {
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "golang"
    }
  }
  depends_on = [
    resource.kubernetes_deployment.golang
  ]
}

resource "kubernetes_namespace" "golang" {
  metadata {
    name = "golang"
  }
}