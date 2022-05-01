# --------------------
# Azure DevOps Project
# --------------------
# Determine project name based on resource group name:
# - fruits-dev-*-rg    => project-fruits
# - veggies-prod-*-rg  => project-veggies
# - infra-shared-*-rg  => central-it

locals {
  project_name = split("-", var.resource_group_name)[0] == "infra" ? "central-it" : "project-${split("-", var.resource_group_name)[0]}"
}

data "azuredevops_project" "team" {
  name = local.project_name
}

# ------------------
# Service Connection
# ------------------
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

resource "azuredevops_serviceendpoint_azurerm" "workspace_endpoint" {
  service_endpoint_name     = "${var.resource_group_name}-connection"
  project_id                = data.azuredevops_project.team.id
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name

  credentials {
    serviceprincipalid  = var.service_principal_id
    serviceprincipalkey = var.service_principal_secret
  }
}
