terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=1.4.0"
    }

		random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}
