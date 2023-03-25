resource "google_storage_bucket" "default" {

  name          = format("%s-bucket", local.default_name)
  storage_class = "STANDARD"
  location      = local.location
  project       = local.project_id

  labels        = local.tags
}
