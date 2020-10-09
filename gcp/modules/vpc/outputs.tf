output "network_name" {
  value = google_compute_network.this.name
}

output "subnetwork_name" {
  value = {
    "us-central1" = google_compute_subnetwork.us-central1.name
  }
}
