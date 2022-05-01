output "resource_group" {
  value = {
    name = azurerm_resource_group.workspace.name
    id   = azurerm_resource_group.workspace.id
  }
}

output "storage_account" {
  value = azurerm_storage_account.storage.name
}
