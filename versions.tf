terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0.0"
    }
    azuredevops = {
      source  = "terraform-providers/azuredevops"
      version = "~> 0.0.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.13"
}
