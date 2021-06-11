output "connection_name" {
	value = azuredevops_serviceendpoint_azurerm.workspace_endpoint.service_endpoint_name
}

output "scope" {
	value = azuredevops_serviceendpoint_azurerm.workspace_endpoint.resource_group
}
