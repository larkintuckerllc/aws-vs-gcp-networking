provider "google" {
  credentials = file("account.json")
  project = "aws-vs-gcp-networking" # REPLACE
}
