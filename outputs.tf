output "workspaces" {
  value = module.workspace[*]
}

output "aad_groups" {
  value = azuread_group.groups[*]
}

output "azure_devops_projects" {
  value = azuredevops_project.team_projects[*]
}

output "azure_devops_standard_permissions" {
  value = module.ado_standard_permissions[*]
}

output "azure_devops_collaboration_permissions" {
  value = {
    fruits  = module.collaboration_permissions_fruits
    veggies = module.collaboration_permissions_veggies
  }
}

output "azure_devops_supermarket_permissions" {
  value = {
    fruits  = module.supermarket_permissions_fruits
    veggies = module.supermarket_permissions_veggies
  }
}
