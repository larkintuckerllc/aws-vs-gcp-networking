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

resource "google_compute_firewall" "allow-ssh-target-bastion" {
  allow {
    ports = [
      "22"
    ]
    protocol = "tcp"
  }
  name     = "allow-ssh-target-bastion"
  network  = google_compute_network.this.name
  priority = 1000
  target_tags = [
    "bastion"
  ]
}

resource "google_compute_firewall" "allow-icmp-source-bastion" {
  allow {
    protocol = "icmp"
  }
  name     = "allow-icmp-source-bastion"
  network  = google_compute_network.this.name
  priority = 1000
  source_tags = [
    "bastion"
  ]
}

resource "google_compute_firewall" "allow-ssh-source-bastion" {
  allow {
    ports = [
      "22"
    ]
    protocol = "tcp"
  }
  name     = "allow-ssh-source-bastion"
  network  = google_compute_network.this.name
  priority = 1000
  source_tags = [
    "bastion"
  ]
}

resource "google_compute_firewall" "allow-http-target-frontend" {
  allow {
    ports = [
      "80"
    ]
    protocol = "tcp"
  }
  name     = "allow-ssh-target-frontend"
  network  = google_compute_network.this.name
  priority = 1000
  target_tags = [
    "frontend"
  ]
}

resource "google_compute_subnetwork" "us-central1" {
  ip_cidr_range = "10.128.0.0/20"
  name          = "us-central1"
  network       = google_compute_network.this.id
  region        = "us-central1"
}

resource "google_compute_instance" "this" {
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  machine_type = "e2-micro"
  name         = "bastion-${var.identifier}"
  network_interface {
    access_config {
        network_tier = "STANDARD"
    }
    network    = google_compute_network.this.name
    subnetwork = google_compute_subnetwork.us-central1.name
  }
  tags = [
    "bastion",
    "public"
  ]
  zone         = "us-central1-a"
}
