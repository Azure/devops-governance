output "connection_name" {
  value       = azuredevops_serviceendpoint_azurerm.workspace_endpoint.service_endpoint_name
  description = "Name of the created Service Connection"
}

output "scope" {
  value       = azuredevops_serviceendpoint_azurerm.workspace_endpoint.resource_group
  description = "Scope (Resource Group) of the created Service Connection"
}
