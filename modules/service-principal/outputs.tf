output "aad_app" {
  value = {
    display_name   = azuread_application.app.display_name
    object_id      = azuread_application.app.object_id
    application_id = azuread_application.app.application_id
  }
  description = "Map with `display_name`, `object_id` and `application_id` properties for the Azure AD application"
}

output "display_name" {
  value       = azuread_application.app.display_name
  description = "Azure AD App Display name"
}

output "principal_id" {
  value       = azuread_service_principal.sp.id
  description = "Principal ID for the Service Principal"
}

output "client_id" {
  value       = azuread_application.app.application_id
  description = "Client ID for Service Principal"
}

output "client_secret" {
  value       = random_password.secret.result
  description = "Client Secret for Service Principal"
  sensitive   = true
}
