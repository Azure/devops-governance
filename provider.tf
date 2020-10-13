# Provision Azure Resources (ARM)
provider "azurerm" {
  version = "=2.26.0"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true # leave nothing behind
    }
  }
}

# # Provision AAD Groups
provider "azuread" {
  version = "=1.0.0"
}

# Store Terraform Stage in Azure Storage Account (see azure.conf.sample)
terraform {
  # backend "azurerm" {
  # }
}

# So we can give current user access to resources too
# b/c we are provisioning from local computer. Will need to change when using CI
data "azurerm_client_config" "current" {}
