terraform {
      required_providers {
	      google = {
		        source = "hashicorp/google"
			      version = "3.5.0"
			          }
				    }
}

provider "google" {

      credentials = file("premvc-20201209-3525c71cf7f8.json")

        project = "premvc-20201209"
	region  = "asia-east1"
	zone    = "asia-east1-b"
}

resource "google_compute_network" "vpc_network" {
      name = "gcp-test1"
      auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "vpc_subnetwork" {
      name = "test-subnetwork"
      ip_cidr_range = "192.168.0.0/16"
      region        = "asia-east1"
      network       = google_compute_network.vpc_network.id
}
