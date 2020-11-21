# Azure AD Groups
# ---------------

resource "azuread_group" "groups" {
  for_each                = var.groups
  name                    = "demo-${each.value}-${local.suffix}"
  prevent_duplicate_names = true
}


# Azure DevOps
# ------------

resource "azuredevops_project" "team_projects" {
  for_each        = var.projects
  project_name    = each.value.name
  description     = each.value.description
  visibility      = "private"
  version_control = "Git"

  features = {
    repositories = "enabled"
    pipelines    = "enabled"
    artifacts    = "disabled"
    boards       = "disabled"
    testplans    = "disabled"
  }
}

module "ado_standard_permissions" {
  for_each       = var.projects
  source         = "./modules/azure-devops-permissions"
  ado_project_id = azuredevops_project.team_projects["proj_${each.value.team}"].id
  team_aad_id    = azuread_group.groups[each.value.team].id
  admin_aad_id   = azuread_group.groups["${each.value.team}_admins"].id
}

# Supermarket Project

resource "azuredevops_project" "supermarket" {
  project_name    = "supermarket"
  description     = "Example: 1 project, many teams, many repos"
  visibility      = "private"
  version_control = "Git"

  features = {
    boards       = "enabled"
    repositories = "enabled"
    pipelines    = "enabled"
    artifacts    = "disabled"
    testplans    = "disabled"
  }
}

module "supermarket_permissions_fruits" {
  source         = "./modules/azure-devops-permissions"
  ado_project_id = azuredevops_project.supermarket.id
  team_aad_id    = azuread_group.groups["fruits"].id
  admin_aad_id   = azuread_group.groups["fruits_admins"].id
}

module "supermarket_permissions_veggies" {
  source         = "./modules/azure-devops-permissions"
  ado_project_id = azuredevops_project.supermarket.id
  team_aad_id    = azuread_group.groups["veggies"].id
  admin_aad_id   = azuread_group.groups["veggies_admins"].id
}

# Shared Collaboration

resource "azuredevops_project" "collaboration" {
  project_name    = "shared-collaboration"
  description     = "Example: what if separate teams should talk to each other? (Disadvantage: cannot link external project commits to work items in this project)"
  visibility      = "private"
  version_control = "Git"

  features = {
    boards       = "enabled"
    repositories = "disabled"
    pipelines    = "disabled"
    artifacts    = "disabled"
    testplans    = "disabled"
  }
}

module "collaboration_permissions_fruits" {
  source         = "./modules/azure-devops-permissions"
  ado_project_id = azuredevops_project.collaboration.id
  team_aad_id    = azuread_group.groups["fruits"].id
  admin_aad_id   = azuread_group.groups["fruits_admins"].id
}

module "collaboration_permissions_veggies" {
  source         = "./modules/azure-devops-permissions"
  ado_project_id = azuredevops_project.collaboration.id
  team_aad_id    = azuread_group.groups["veggies"].id
  admin_aad_id   = azuread_group.groups["veggies_admins"].id
}


# Workspaces
# ----------

module "workspace" {
  for_each             = var.environments
  source               = "./modules/azure-resources"
  name                 = "${each.value.team}-${each.value.env}-${local.suffix}"
  team_group_id        = azuread_group.groups[each.value.team].id
  admin_group_id       = azuread_group.groups[each.value.team].id
  superadmins_group_id = var.superadmins_aad_object_id
}


# Service Connections for ADO
# ---------------------------

module "service_connections" {
  for_each             = module.workspace
  source               = "./modules/azure-devops-service-connection"
  service_principal_id = each.value.service_principals[0].application_id
  key_vault_name       = each.value.key_vault
  resource_group_name  = each.value.resource_group_name
}
