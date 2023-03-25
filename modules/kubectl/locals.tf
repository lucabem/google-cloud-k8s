locals {
    kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${data.gcp_gke_cluster.cluster.endpoint}
    certificate-authority-data: ${data.gcp_gke_cluster.cluster.certificate_authority.0.data}
  name: kubernetes
KUBECONFIG
}

data "gcp_gke_cluster" "cluster" {
  name = var.cluster_id
}

data "gcp_gke_cluster_auth" "cluster" {
  name = var.cluster_id
}
