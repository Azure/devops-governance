# SERVICE_PRINCIPALS
# ------------------

# SP - Workspace (scoped to resource group)

resource "azuread_application" "workspace_sp" {
  display_name = "${local.name}-rg-sp"
  depends_on = [
    azurerm_resource_group.workspace
  ]
}

resource "azuread_application_password" "workspace_sp_secret" {
  application_object_id = azuread_application.workspace_sp.object_id
  value                 = random_password.workspace_sp.result
  end_date_relative     = "4380h" # 6 months
}

resource "azuread_service_principal" "workspace_sp" {
  application_id = azuread_application.workspace_sp.application_id
}


# SP - Key Vault Reader (just for Azure Pipeline)

resource "azuread_application" "kv_reader_sp" {
  display_name = "${local.name}-kv-reader-sp"
}

resource "azuread_application_password" "kv_reader_sp_secret" {
  application_object_id = azuread_application.kv_reader_sp.object_id
  value                 = random_password.kv_reader_sp.result
  end_date_relative     = "4380h" # 6 months
}

resource "azuread_service_principal" "kv_reader_sp" {
  application_id = azuread_application.kv_reader_sp.application_id
}

# Random Passwords

resource "random_password" "workspace_sp" {
  length           = 30
  special          = true
  min_numeric      = 5
  min_special      = 2
  override_special = "-_%@?"
}

resource "random_password" "kv_reader_sp" {
  length           = 30
  special          = true
  min_numeric      = 5
  min_special      = 2
  override_special = "-_%@?"
}
