# Owners
# ------

resource "azurerm_role_assignment" "team_admins" {
  role_definition_name = "Owner"
  principal_id         = var.admin_group_id
  scope                = azurerm_resource_group.workspace.id
}

# Contributors
# ------------

# Service Principal

resource "azurerm_role_assignment" "workspace_sp" {
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.workspace_sp.id
  scope                = azurerm_resource_group.workspace.id
}

# AAD Group

resource "azurerm_role_assignment" "team_members" {
  role_definition_name = "Contributor"
  principal_id         = var.team_group_id
  scope                = azurerm_resource_group.workspace.id
}
