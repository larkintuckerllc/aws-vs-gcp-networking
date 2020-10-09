resource "google_compute_network" "this" {
  auto_create_subnetworks = false
  delete_default_routes_on_create = true
  name                    = var.identifier
  routing_mode            = "REGIONAL"
}

resource "google_compute_route" "default-route-public" {
  description      = "Default route to the Internet."
  dest_range       = "0.0.0.0/0"
  name             = "default-route-public"
  network          = google_compute_network.this.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  tags = [
    "public"
  ]
}

resource "google_compute_firewall" "default-allow-ssh-bastion" {
  allow {
    ports = [
      "22"
    ]
    protocol = "tcp"
  }
  name     = "default-allow-ssh-bastion"
  network  = google_compute_network.this.name
  priority = 65534
  target_tags = [
    "bastion"
  ]
}

# TODO: FIREWALL INTERNAL

resource "google_compute_subnetwork" "us-central1" {
  ip_cidr_range = "10.128.0.0/20"
  name          = "us-central1"
  network       = google_compute_network.this.id
  region        = "us-central1"
}
