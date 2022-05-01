# ---------------
# Azure AD Groups
# ---------------

output "aad_groups" {
  value = [
    for group in azuread_group.groups :
    group.display_name
  ]
}

# ------------------------------
# Resource Groups ("Workspaces")
# ------------------------------

output "arm_environments" {
  value = [
    for env in module.arm_environments : {
      resource_group  = env.resource_group.name
      storage_account = env.storage_account
    }
  ]
}

# ------------------
# Service Principals
# ------------------

output "service_principals" {
  value = [
    for sp in module.service_principals :
    sp.display_name
  ]
}

# ------------------
# Azure DevOps (ADO)
# ------------------

output "azure_devops_projects" {
  value = [
    for proj in azuredevops_project.team_projects : {
      name        = proj.name
      description = proj.description
      features    = proj.features
      visibility  = proj.visibility
    }
  ]
}

# ADO Security Groups

output "azure_devops_service_connections" {
  value = module.service_connections[*]
}

output "azure_devops_team_permissions" {
  value = module.ado_team_permissions[*]
}

output "azure_devops_collaboration_permissions" {
  value = {
    fruits  = module.ado_collaboration_permissions_fruits
    veggies = module.ado_collaboration_permissions_veggies
  }
}

output "azure_devops_supermarket_permissions" {
  value = {
    fruits  = module.ado_supermarket_permissions_fruits
    veggies = module.ado_supermarket_permissions_veggies
  }
}
