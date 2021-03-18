# Store Terraform Stage in Azure Storage Account (see azure.conf.sample)
terraform {
  backend "azurerm" {
  }
}

# Configure Providers
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true # leave nothing behind
    }
  }
}

provider "azuread" {
}

provider "azuredevops" {
}

# So we can give current user access to resources too
# b/c we are provisioning from local computer. Will need to change when using CI
data "azurerm_client_config" "current" {}
