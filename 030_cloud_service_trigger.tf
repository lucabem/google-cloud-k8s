resource "google_cloudbuild_trigger" "trigger_on_push_on_main_repo" {
  location    = local.region
  name        = "launch-cloud-build-on-push-to-main"
  description = "Generates docker images for production env. Needed approval"

  github {
    owner = local.owner
    name  = "mms-cloud-skeleton"
    push {
      branch = "^master$"
    }
  }

  approval_config {
     approval_required = false 
  }

  substitutions = {
    _REPOSITORY = google_artifact_registry_repository.repo_docker_images.name
    _IMAGE      = local.image_name
  }

  service_account = "projects/-/serviceAccounts/825452531530-compute@developer.gserviceaccount.com"

  filename = "ci/cloud-build.yaml"

  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"

}


resource "google_cloudbuild_trigger" "trigger_on_push_on_dev_repo" {
  location    = local.region
  name        = "launch-cloud-build-on-non-production-env"
  description = "Generates docker images for non-production env. Not needed approval"

  github {
    owner = local.owner
    name  = "mms-cloud-skeleton"
    push {
      branch = "^master$"
      invert_regex = true
    }
  }

  approval_config {
     approval_required = false 
  }

  substitutions = {
    _REPOSITORY = google_artifact_registry_repository.repo_docker_images.name
    _IMAGE      = local.image_name
  }

  filename = "ci/cloud-build.yaml"

  service_account = "projects/-/serviceAccounts/825452531530-compute@developer.gserviceaccount.com"

  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"

}

