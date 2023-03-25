resource "google_artifact_registry_repository" "repo_docker_images" {
  location      = local.region
  repository_id = format("%s-cloud-repo", local.default_name)
  description   = "Repo for Docker images used on MediaMarkt Hackathon"
  format        = "DOCKER"
  project       = local.project_id

  labels        = local.tags
}


