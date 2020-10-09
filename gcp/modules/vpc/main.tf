resource "google_compute_network" "this" {
  auto_create_subnetworks = false
  name                    = var.identifier
  routing_mode            = "REGIONAL"
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

resource "google_compute_firewall" "allow-http-target-backend" {
  allow {
    ports = [
      "80"
    ]
    protocol = "tcp"
  }
  name     = "allow-http-target-backend"
  network  = google_compute_network.this.name
  priority = 1000
  source_tags = [
    "frontend"
  ]
  target_tags = [
    "backend"
  ]
}

resource "google_compute_subnetwork" "us-central1" {
  ip_cidr_range = "10.128.0.0/20"
  name          = "us-central1"
  network       = google_compute_network.this.id
  region        = "us-central1"
}

resource "google_compute_router" "us-central1" {
  name    = "us-central1-${var.identifier}"
  network = google_compute_network.this.id
  region  = google_compute_subnetwork.us-central1.region
}

resource "google_compute_router_nat" "us-central1" {
  name                               = "us-central1-${var.identifier}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  router                             = google_compute_router.us-central1.name
  region                             = google_compute_router.us-central1.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
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
    "bastion"
  ]
  zone         = "us-central1-a"
}
