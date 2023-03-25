locals {
  project_id = "axkfjq0kgst4vrop0zyw812xwjmjtg"
  region     = "europe-west1"
  zone       = "europe-west1-a"
  sponsor    = "mmds-nuwe"
  owner      = "lucabem"

  default_name = format("%s-%s", local.sponsor, local.owner)

  location = "EU"

  image_name  = "mms-cloud-web"

  tags = {
    company   = "nuwe"
    sponsor   = "mediamarkt"
    owner     = "lucabem"
    terraform = "true"
  }

}
