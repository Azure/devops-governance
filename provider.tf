terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=1.5.1"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.63.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }

  required_version = ">= 0.15"
}

provider "azurerm" {
  features {
  }
}
