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
