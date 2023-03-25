################################################################################
# GOOGLE CONTAINER CLUSTER
################################################################################

resource "google_container_cluster" "gcc_cluster" {
  name                     = format("%s-%s", local.default_name, "cluster")
  location                 = local.region
  initial_node_count       = 1
  remove_default_node_pool = false

  resource_labels = local.tags
}

data "google_client_config" "default" {

}

################################################################################
# NAMESPACE
################################################################################
resource "kubernetes_namespace" "namespace_app_web" {
  metadata {
    labels = local.tags
    name   = "mediamarkt-web-ns"
  }

  depends_on = [
    google_container_cluster.gcc_cluster
  ]
}


################################################################################
# DEPLOYMENT
################################################################################
resource "kubernetes_deployment" "deployment_app_web" {
  metadata {
    name      = "nuwe-web-app"
    namespace = kubernetes_namespace.namespace_app_web.metadata[0].name
    labels    = local.tags
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nuwe-web-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "nuwe-web-app"
        }
      }
      spec {
        container {
          name = "nuwe-web-app"
          image = format(
            "%s-docker.pkg.dev/%s/%s/%s:%s",
            local.region, local.project_id, google_artifact_registry_repository.repo_docker_images.name, local.image_name, var.image_tag
          )
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

################################################################################
# SERVICE
################################################################################
# resource "kubernetes_service" "service_app_web" {
#   metadata {
#     name      = "nuwe-app"
#     namespace = kubernetes_namespace.namespace_app_web.metadata[0].name
#     labels    = local.tags
#   }
#   spec {
#     selector = {
#       app = kubernetes_deployment.deployment_app_web.spec[0].template[0].metadata[0].labels.app
#     }
#     type = "LoadBalancer"
#     port {
#       port        = 80
#       target_port = 3000
#     }
#   }
# }

data "kubectl_path_documents" "service_app_web" {
  pattern = "./manifests/web_service.yaml"
  vars = {
    name         = "nuwe-service-app"
    namespace    = kubernetes_namespace.namespace_app_web.metadata[0].name
    app          = kubernetes_deployment.deployment_app_web.spec[0].template[0].metadata[0].labels.app
    port         = 80
    target_port  = 3000
    type_service = "LoadBalancer"
  }
}


resource "kubectl_manifest" "service_app_web" {
  count            = length(data.kubectl_path_documents.service_app_web.documents)
  yaml_body        = element(data.kubectl_path_documents.service_app_web.documents, count.index)
  force_new        = true
  wait             = true
  wait_for_rollout = true

  depends_on = [
    kubernetes_deployment.deployment_app_web
  ]
}
