output "resource_group" {
  value = {
    name = azurerm_resource_group.workspace.name
    id   = azurerm_resource_group.workspace.id
  }
  description = "HCL map/object of resource group with `name` and `id` properties."
}

output "storage_account" {
  value       = azurerm_storage_account.storage.name
  description = "Name of created Storage Account"
}

output "key_vault" {
  value       = azurerm_key_vault.kv.name
  description = "Name of created Key Vault"
}
