terraform {
  backend "gcs" {
    bucket = "lineten-terraform-state"
    prefix = "terraform/state"
  }
}
