output "contributors" {
  value = {
    origin         = azuredevops_group.team_group.origin
    principal_name = azuredevops_group.team_group.principal_name
    project_role   = data.azuredevops_group.contributors.name
    subject_kind   = azuredevops_group.team_group.subject_kind
  }
}

output "project_admins" {
  value = {
    origin         = azuredevops_group.admins_group.origin
    principal_name = azuredevops_group.admins_group.principal_name
    project_role   = data.azuredevops_group.admins.name
    subject_kind   = azuredevops_group.admins_group.subject_kind
  }
}
