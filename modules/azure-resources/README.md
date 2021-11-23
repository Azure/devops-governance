<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_resource_group.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.kv_superadmins](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.kv_team_admins](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.kv_team_devs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rg_sp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rg_team_admins](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rg_team_devs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admins_group_id"></a> [admins\_group\_id](#input\_admins\_group\_id) | AAD Group ID to receive 'Owner' permissions | `string` | n/a | yes |
| <a name="input_client_object_id"></a> [client\_object\_id](#input\_client\_object\_id) | Object ID for Azure Resource Manager (ARM) client. Defaults to current session. | `string` | `""` | no |
| <a name="input_client_tenant_id"></a> [client\_tenant\_id](#input\_client\_tenant\_id) | AAD Tenant ID for Azure Resource Manager (ARM) client. Defaults to current session. | `string` | `""` | no |
| <a name="input_devs_group_id"></a> [devs\_group\_id](#input\_devs\_group\_id) | AAD Group ID to receive 'Contributor' permissions | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure Region for resources. Defaults to Europe West. | `string` | `"westeurope"` | no |
| <a name="input_name"></a> [name](#input\_name) | Base name of your workspace that will be used in resource names. Please use lowercase with dashes. | `string` | n/a | yes |
| <a name="input_service_principal_id"></a> [service\_principal\_id](#input\_service\_principal\_id) | Required: Service Principal ID for build agent for this Resource Group to receive 'Contributor' permissions. | `string` | n/a | yes |
| <a name="input_superadmins_group_id"></a> [superadmins\_group\_id](#input\_superadmins\_group\_id) | Required: object ID of the AAD group for super admins, used to apply key vault access policies. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to Azure Resources | `map(string)` | <pre>{<br>  "demo": "governance",<br>  "devops": "true",<br>  "oss": "terraform",<br>  "public": "true"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault"></a> [key\_vault](#output\_key\_vault) | Name of created Key Vault |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | HCL map/object of resource group with `name` and `id` properties. |
| <a name="output_storage_account"></a> [storage\_account](#output\_storage\_account) | Name of created Storage Account |
<!-- END_TF_DOCS -->