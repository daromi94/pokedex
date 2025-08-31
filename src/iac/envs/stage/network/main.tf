locals {
  environment = "stage"
}

data "google_client_config" "this" {}

locals {
  project = data.google_client_config.this.project
  region  = data.google_client_config.this.region
}

resource "google_compute_network" "this" {
  project = local.project

  name                    = "pokedex-${local.environment}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "proxy_only_1" {
  depends_on = [google_compute_network.this]

  project = local.project
  region  = local.region

  network       = google_compute_network.this.self_link
  name          = "lb-proxy-1"
  ip_cidr_range = "10.83.2.0/23"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}
