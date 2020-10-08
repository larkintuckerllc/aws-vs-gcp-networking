resource "google_compute_network" "this" {
  auto_create_subnetworks = false
  delete_default_routes_on_create = true
  name                    = var.identifier
  routing_mode            = "REGIONAL"
}
