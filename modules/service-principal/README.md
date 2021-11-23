<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=1.4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >=1.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.workspace_sp_secret](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [random_password.secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name for service principal | `string` | n/a | yes |
| <a name="input_password_lifetime"></a> [password\_lifetime](#input\_password\_lifetime) | Lifetime of password in hours, e.g. '720h'. Defaults to 6 months. After password expires, credential needs to be refreshed (but not deleted). | `string` | `"4380h"` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure AD Tenant ID | `string` | `"Current Client Tenant ID"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aad_app"></a> [aad\_app](#output\_aad\_app) | n/a |
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | Client ID for Service Principal |
| <a name="output_client_secret"></a> [client\_secret](#output\_client\_secret) | Client Secret for Service Principal |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | n/a |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | n/a |
<!-- END_TF_DOCS -->