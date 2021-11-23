# Custom Terraform Modules

View subdirectories to see [terraform-docs.io](https://terraform-docs.io/) auto-generated documentation for each module.

## [`azure-devops-permissions`](./azure-devops-permissions)

For a given Azure DevOps project, this module takes following inputs:

- `ado_project_id` - Azure DevOps Project ID
- `admin_aad_id` - AAD Group ID to receive 'Project Administrator' permissions
- `team_aad_id` - AAD Group ID to receive 'Contributor' permissions

#### Outputs

e.g.

```hcl
output "project_admins" {
  value = {
    origin         = azuredevops_group.admins_group.origin
    principal_name = azuredevops_group.admins_group.principal_name
    project_role   = data.azuredevops_group.admins.name
    subject_kind   = azuredevops_group.admins_group.subject_kind
  }
}
```

## [`azure-devops-service-connection`](./azure-devops-service-connection)

Creates a [Service Connection](https://docs.microsoft.com/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml), an Azure DevOps specific wrapper around a [Service Principal](https://docs.microsoft.com/azure/active-directory/develop/app-objects-and-service-principals#service-principal-object). This module takes following inputs:

- `input_resource_group_name` - Name of resource group of this workspace the service principal is scoped to
- `input_service_principal_id` - Client ID for Service Principal
- `input_service_principal_secret` - Client Secret for Service Principal

#### Outputs

- Service Connection name
- Resource Group name (corresponding to service connection)

## [`azure-resources`](./azure-resources)

Creates example Azure resources

- Azure Resource Group
- Azure Key Vault
- Storage Account

And sets the following RBAC model

- Service principal receives `Contributor` permissions
- Team default e.g. developers receive `Contributor` permissions
- Team admins receive `Owner` permissions
- Local Admins group get Owner access via [Key Vault Access Policy](https://docs.microsoft.com/azure/key-vault/general/assign-access-policy?tabs=azure-portal)

#### Outputs

Names of resource group, key vault and storage account

## [`service-principal`](./service-principal)

Custom Module to piece together Azure AD Application, App Password and Service Principal resources necessary to create Service Principal with Client ID and Client Secret to use for deployments.

#### Outputs

See [service-principal/README.md](./service-principal/README.md)