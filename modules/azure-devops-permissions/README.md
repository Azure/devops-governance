<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >=0.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | >=0.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuredevops_group.admins_group](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/group) | resource |
| [azuredevops_group.team_group](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/group) | resource |
| [azuredevops_group_membership.admins](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/group_membership) | resource |
| [azuredevops_group_membership.team](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/group_membership) | resource |
| [azuredevops_group.admins](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/group) | data source |
| [azuredevops_group.contributors](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_aad_id"></a> [admin\_aad\_id](#input\_admin\_aad\_id) | AAD Group ID to receive 'Project Administrator' permissions | `string` | n/a | yes |
| <a name="input_ado_project_id"></a> [ado\_project\_id](#input\_ado\_project\_id) | Azure DevOps Project ID | `string` | n/a | yes |
| <a name="input_team_aad_id"></a> [team\_aad\_id](#input\_team\_aad\_id) | AAD Group ID to receive 'Contributor' permissions | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_contributors"></a> [contributors](#output\_contributors) | Output membership in 'Contributors' role as HCL map/object with `origin`, `principal_name`, `project_role` and `subject_kind` properties. |
| <a name="output_project_admins"></a> [project\_admins](#output\_project\_admins) | Output membership in 'Project Administrators' role as an HCL map/object with `origin`, `principal_name`, `project_role` and `subject_kind` properties. |
<!-- END_TF_DOCS -->