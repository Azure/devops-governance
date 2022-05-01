terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.22.0"
    }
  }
  required_version = ">= 0.15"
}
