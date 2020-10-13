# RESOURCE GROUP
# --------------

resource "azurerm_resource_group" "workspace" {
  name     = "${local.name}-rg"
  location = var.location
  tags     = var.tags
}

# STORAGE ACCOUNT
# ---------------

resource "azurerm_storage_account" "storage" {
  name                     = local.name_squished
  resource_group_name      = azurerm_resource_group.workspace.name
  location                 = azurerm_resource_group.workspace.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
  tags                     = var.tags
}

# AZURE KEY VAULT
# ---------------

resource "azurerm_key_vault" "kv" {
  name                        = "${local.name}-kv"
  location                    = azurerm_resource_group.workspace.location
  resource_group_name         = azurerm_resource_group.workspace.name
  enabled_for_disk_encryption = true
  tenant_id                   = local.client_tenant_id
  soft_delete_enabled         = true  # false is deprecated
  soft_delete_retention_days  = 7     # minimum
  purge_protection_enabled    = false # so we can fully delete it
  sku_name                    = "standard"
  tags                        = var.tags
}

# Key Vault Access Policy - me
# Note: this assumes ARM client is central owner of all workspaces

resource "azurerm_key_vault_access_policy" "me" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id    = local.client_object_id
  tenant_id    = local.client_tenant_id

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]
}

# Key Vault Access Policy - workspace service principal

resource "azurerm_key_vault_access_policy" "workspace_sp" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id    = azuread_application.workspace_sp.object_id
  tenant_id    = local.client_tenant_id

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]
}

# Key Vault Access Policy - Read-only e.g. for Azure DevOps

resource "azurerm_key_vault_access_policy" "kv_reader" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id    = azuread_application.kv_reader_sp.object_id
  tenant_id    = local.client_tenant_id

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
}


# KEY VAULT SECRETS
# -----------------
# Examples and our service principal credentials

resource "azurerm_key_vault_secret" "workspace_sp_secret" {
  name         = "workspace-sp-secret"
  value        = random_password.workspace_sp.result
  key_vault_id = azurerm_key_vault.kv.id
  tags         = var.tags

  depends_on = [
    azurerm_key_vault_access_policy.me
  ]
}

resource "azurerm_key_vault_secret" "kv_reader_sp_secret" {
  name         = "kv-reader-sp-secret"
  value        = random_password.kv_reader_sp.result
  key_vault_id = azurerm_key_vault.kv.id
  tags         = var.tags

  depends_on = [
    azurerm_key_vault_access_policy.me
  ]
}
