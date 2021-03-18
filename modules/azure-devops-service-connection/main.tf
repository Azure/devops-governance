# 1 - get Service Principal secret from Key Vault

data "azurerm_key_vault" "workspace" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "sp_secret" {
  name         = local.sp_secret_name
  key_vault_id = data.azurerm_key_vault.workspace.id
}

# 2 - get reference to ADO Project

data "azuredevops_project" "team" {
  name = local.project_name
}

# 3 -get Subscription Info

data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

# 4 - finally create Service Connection in ADO project

resource "azuredevops_serviceendpoint_azurerm" "workspace_endpoint" {
  project_id            = data.azuredevops_project.team.id
  service_endpoint_name = local.connection_name
  credentials {
    serviceprincipalid  = var.service_principal_id
    serviceprincipalkey = data.azurerm_key_vault_secret.sp_secret.value
  }
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}
