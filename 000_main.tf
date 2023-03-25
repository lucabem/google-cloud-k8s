terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.52"
    }
    kubernetes = {
      version = "~> 2.13"
    }

  }

  backend "gcs" {
    bucket = "axkfjq0kgst4vrop0zyw812xwjmjtg-tfstate"
    prefix = "state"
  }

  required_version = ">= 1.2.0"
}



provider "google" {
  project = local.project_id
  region  = local.region
  zone    = local.zone
}

provider "kubernetes" {
  host  = "https://${google_container_cluster.gcc_cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.gcc_cluster.master_auth[0].cluster_ca_certificate,
  )
}