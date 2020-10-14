# RBAC Example for Key Vault
# --------------------------
# Key Vault access is managed on the data plane
# Instead of applying role assignments, we apply key
# vault access policies.
#
# In this demo's organization, only admins have access to
# destructive functionality.

resource "azurerm_key_vault_access_policy" "team_group" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id    = var.team_group_id
  tenant_id    = local.client_tenant_id

  secret_permissions = [
    "backup",
    # "delete", 	# Admins-only
    "get",
    "list",
    # "purge",  	# Admins-only
    # "recover", 	# Admins-only
    "restore",
    "set"
  ]
}

resource "azurerm_key_vault_access_policy" "admins_group" {
  key_vault_id = azurerm_key_vault.kv.id
  object_id    = var.admin_group_id
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

# Important Footnotes
#
# - For brevity, this demo only applies permissions to secrets.
#   In real life, you will want to do the same for certificates
#   and keys.
#
# - In real life, you probably want to give developers admin
#   access to the key vault in their development environment.
#
# - As of Oct 2020 there is an alternate permissions model,
#   the RBAC Permission Model, which is in preview. For details, see:
#   https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide
