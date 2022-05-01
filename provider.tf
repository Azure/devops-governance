terraform {
  backend "azurerm" {}

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.22.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.4.0"
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
