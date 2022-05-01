# Service Principal
# ------------------
# See https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals

resource "azuread_application" "app" {
  display_name = local.name
  owners       = var.owners
}

resource "azuread_service_principal_password" "workspace_sp_secret" {
  service_principal_id = azuread_service_principal.sp.object_id
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.app.application_id
  owners         = var.owners
}
