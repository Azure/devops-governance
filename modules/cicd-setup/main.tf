terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.4.0"
    }
  }
  required_version = ">= 0.15"
}

provider "azurerm" {
  features {}
}


# ========
#  Config
# ========

locals {
  headless_owner_name = "governance-demo-github-cicd"
  owners_group_name   = "governance-demo-subscription-owners"
}

data "azurerm_subscription" "visual_studio" {}
data "azuread_client_config" "current" {}
data "azurerm_client_config" "current" {}


# ==================================
#  Headless Owner Service Principal
# ==================================

resource "azuread_application" "headless_owner" {
  display_name = local.headless_owner_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "headless_owner" {
  application_id               = azuread_application.headless_owner.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
  tags = [
    "ci-managed:false",
    "demo:true"
  ]
}

resource "azuread_service_principal_password" "headless_owner" {
  service_principal_id = azuread_service_principal.headless_owner.object_id
}

# ==================
#  Owners AAD Group
# ==================

resource "azuread_group" "superowners" {
  display_name            = local.owners_group_name
  security_enabled        = true
  prevent_duplicate_names = true
  owners                  = [data.azuread_client_config.current.object_id]
  members = [
    data.azuread_client_config.current.object_id,
    azuread_service_principal.headless_owner.id
  ]
}


# =========================
#  "Owner" Role Assignment
# =========================

resource "azurerm_role_assignment" "gov_demo_owners_group" {
  scope                = data.azurerm_subscription.visual_studio.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.superowners.object_id
}


# =========
#  Outputs
# =========

output "aad_superowners_group_id" {
  value = azuread_group.superowners.object_id
}

output "headless_owner_sp" {
  value = {
    display_name   = azuread_application.headless_owner.display_name
    object_id      = azuread_application.headless_owner.object_id
    application_id = azuread_application.headless_owner.application_id
  }
}
