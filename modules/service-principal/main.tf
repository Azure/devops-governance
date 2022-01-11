# Service Principal
# ------------------
# See https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals

resource "azuread_application" "app" {
  display_name = local.name
}

resource "azuread_application_password" "workspace_sp_secret" {
  application_object_id = azuread_application.app.object_id
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.app.application_id
}
