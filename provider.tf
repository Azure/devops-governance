provider "azurerm" {
  version = "=2.20.0"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true # leave nothing behind
    }
  }
}

terraform {
  backend "azurerm" {
  }
}
