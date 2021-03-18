terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.50.0"
    }
  }
}
