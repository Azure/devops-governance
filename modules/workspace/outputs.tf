output "resource_group_name" {
  value = azurerm_resource_group.workspace.name
}

output "storage_account" {
  value = azurerm_storage_account.storage.name
}

output "key_vault" {
  value = azurerm_key_vault.kv.name
}

output "service_principals" {
  value =  [
    {
      display_name   = azuread_application.workspace_sp.name
      object_id      = azuread_application.workspace_sp.object_id
      application_id = azuread_application.workspace_sp.application_id
    },
    {
      display_name   = azuread_application.kv_reader_sp.name
      object_id      = azuread_application.kv_reader_sp.object_id
      application_id = azuread_application.kv_reader_sp.application_id
    }
  ]
}
