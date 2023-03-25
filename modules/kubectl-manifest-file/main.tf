terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}

locals {
  is_http = trimprefix(var.kubectl_manifest_file_path, "http") != var.kubectl_manifest_file_path // like startswith(var.kubectl_manifest_file_path, "http")
}

data "http" "self" {
  count = local.is_http ? 1 : 0
  url = var.kubectl_manifest_file_path
}

data "kubectl_file_documents" "self" {
  content = local.is_http ? data.http.self[0].response_body : file(var.kubectl_manifest_file_path)
}

resource "kubectl_manifest" "self" {
  count     = length(data.kubectl_file_documents.self.documents)
  yaml_body = element(data.kubectl_file_documents.self.documents, count.index)
  force_new = var.force_new
  wait = var.wait
  wait_for_rollout = var.wait_for_rollout

  depends_on = [
    data.kubectl_file_documents.self
  ]
}
