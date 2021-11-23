<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >=0.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | >=0.1.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_azurerm.workspace_endpoint](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_project.team](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group of this workspace the service principal is scoped to. | `string` | n/a | yes |
| <a name="input_service_principal_id"></a> [service\_principal\_id](#input\_service\_principal\_id) | Client ID for Service Principal | `string` | n/a | yes |
| <a name="input_service_principal_secret"></a> [service\_principal\_secret](#input\_service\_principal\_secret) | Client Secret for Service Principal | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | Name of the created Service Connection |
| <a name="output_scope"></a> [scope](#output\_scope) | Scope (Resource Group) of the created Service Connection |
<!-- END_TF_DOCS -->