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
