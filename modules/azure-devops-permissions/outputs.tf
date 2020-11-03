output "azure_devops_groups" {
  value = {
    contributors = {
      origin         = azuredevops_group.team_group.origin
      principal_name = azuredevops_group.team_group.principal_name
      project_role   = data.azuredevops_group.contributors.name
      project_id     = data.azuredevops_group.contributors.project_id
      subject_kind   = azuredevops_group.team_group.subject_kind
    }
    admins = {
      origin         = azuredevops_group.admins_group.origin
      principal_name = azuredevops_group.admins_group.principal_name
      project_role   = data.azuredevops_group.admins.name
      project_id     = data.azuredevops_group.admins.project_id
      subject_kind   = azuredevops_group.admins_group.subject_kind
    }
  }
}
