# --------------
# Resource Group
# --------------

resource "azurerm_resource_group" "workspace" {
  name     = "${local.name}-rg"
  location = var.location
  tags     = var.tags
}

# ---------------
# Storage Account
# ---------------

resource "azurerm_storage_account" "storage" {
  name                     = local.name_squished
  resource_group_name      = azurerm_resource_group.workspace.name
  location                 = azurerm_resource_group.workspace.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# ---------------
# Azure Key Vault
# ---------------

resource "azurerm_key_vault" "kv" {
  name                        = "${local.name}-kv"
  location                    = azurerm_resource_group.workspace.location
  resource_group_name         = azurerm_resource_group.workspace.name
  enabled_for_disk_encryption = true
  tenant_id                   = local.client_tenant_id
  soft_delete_retention_days  = 7     # minimum
  purge_protection_enabled    = false # so we can fully delete it
  sku_name                    = "standard"
  tags                        = var.tags
  enable_rbac_authorization   = true
}

# -----------------------
# RBAC - Role Assignments
# -----------------------

# Resource Group - Team Admins

resource "azurerm_role_assignment" "rg_team_admins" {
  role_definition_name = "Owner"
  principal_id         = var.admins_group_id
  scope                = azurerm_resource_group.workspace.id
}

# Resource Group - Team Devs

resource "azurerm_role_assignment" "rg_team_devs" {
  role_definition_name = "Contributor"
  principal_id         = var.devs_group_id
  scope                = azurerm_resource_group.workspace.id
}

# Resource Group - Service Principal

resource "azurerm_role_assignment" "rg_sp" {
  role_definition_name = "Contributor"
  principal_id         = var.service_principal_id
  scope                = azurerm_resource_group.workspace.id
}

# Key Vault - Superadmins (i.e. organization - top level admins)

resource "azurerm_role_assignment" "kv_superadmins" {
  role_definition_name = "Key Vault Administrator" # note: takes up to 10 minutes to propagate
  principal_id         = var.superadmins_group_id
  scope                = azurerm_key_vault.kv.id
}

# Key Vault - Team Admins

resource "azurerm_role_assignment" "kv_team_admins" {
  role_definition_name = "Key Vault Administrator" # note: takes up to 10 minutes to propagate
  principal_id         = var.admins_group_id
  scope                = azurerm_key_vault.kv.id
}

# Key Vault - Devs

resource "azurerm_role_assignment" "kv_team_devs" {
  role_definition_name = "Key Vault Secrets User" # note: takes up to 10 minutes to propagate
  principal_id         = var.devs_group_id
  scope                = azurerm_key_vault.kv.id
}

# # Key Vault - Service Principal (team should create own sps/rbac per app)

# resource "azurerm_role_assignment" "kv_workspace_sp" {
#   role_definition_name = "Key Vault Secrets User" # note: takes up to 10 minutes to propagate
#   principal_id         = var.devs_group_id
#   scope                = azurerm_key_vault.kv.id
# }

# Why does it take up to 10 minutes for Key Vault RBAC to propagate?
# See https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#known-limits-and-performance
