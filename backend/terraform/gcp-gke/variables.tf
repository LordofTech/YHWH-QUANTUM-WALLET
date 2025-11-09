
variable "project" { type = string }
variable "region"  { type = string  default = "europe-west1" }
variable "cluster_name" { type = string default = "quantum-wallet-gke" }
variable "locations" { type = list(string) default = ["europe-west1-b"] }
