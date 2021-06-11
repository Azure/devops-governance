data "azurerm_client_config" "current" {}

# Suffix
# ------
# Some Azure resources, e.g. storage accounts must have globally
# unique names. Use a suffix to avoid automation errors.

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result

  # Default to current ARM client
  superadmins_aad_object_id = var.superadmins_aad_object_id == "" ? data.azurerm_client_config.current.object_id : var.superadmins_aad_object_id
}


# Azure AD Groups
# ---------------

resource "azuread_group" "groups" {
  for_each                = var.groups
  display_name            = "demo-${each.value}-${local.suffix}"
  prevent_duplicate_names = true
}

# ------------------
# Service Principals
# ------------------

# TODO: document use for CI only. Apps should use diff. SP per PILP

module "service_principals" {
  for_each = var.environments
  source   = "./modules/service-principal"
  name     = "${each.value.team}-${each.value.env}-${local.suffix}-ci-sp"
}

# ------------------------------
# Resource Groups ("Workspaces")
# ------------------------------

module "arm_environments" {
  for_each             = var.environments
  source               = "./modules/azure-resources"
  name                 = "${each.value.team}-${each.value.env}-${local.suffix}"
  devs_group_id        = azuread_group.groups["${each.value.team}_devs"].id
  admins_group_id      = azuread_group.groups["${each.value.team}_admins"].id
  superadmins_group_id = local.superadmins_aad_object_id
  service_principal_id = module.service_principals["${each.value.team}_${each.value.env}"].principal_id
}

# Azure DevOps
# ------------

resource "azuredevops_project" "team_projects" {
  for_each        = var.projects
  name            = each.value.name
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
  team_aad_id    = azuread_group.groups["${each.value.team}_devs"].id
  admin_aad_id   = azuread_group.groups["${each.value.team}_admins"].id
}

# Supermarket Project

resource "azuredevops_project" "supermarket" {
  name            = "supermarket"
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

# TODO: supermarket collab model with devs, admins and all
module "supermarket_permissions_fruits" {
  source         = "./modules/azure-devops-permissions"
  ado_project_id = azuredevops_project.supermarket.id
  team_aad_id    = azuread_group.groups["fruits_devs"].id
  admin_aad_id   = azuread_group.groups["fruits_admins"].id
}

module "supermarket_permissions_veggies" {
  source         = "./modules/azure-devops-permissions"
  ado_project_id = azuredevops_project.supermarket.id
  team_aad_id    = azuread_group.groups["veggies_devs"].id
  admin_aad_id   = azuread_group.groups["veggies_admins"].id
}

# Shared Collaboration

resource "azuredevops_project" "collaboration" {
  name            = "shared-collaboration"
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
  team_aad_id    = azuread_group.groups["fruits_devs"].id
  admin_aad_id   = azuread_group.groups["fruits_admins"].id
}

module "collaboration_permissions_veggies" {
  source         = "./modules/azure-devops-permissions"
  ado_project_id = azuredevops_project.collaboration.id
  team_aad_id    = azuread_group.groups["veggies_devs"].id
  admin_aad_id   = azuread_group.groups["veggies_admins"].id
}


# Workspaces
# ----------

module "workspace" {
  for_each             = var.environments
  source               = "./modules/azure-resources"
  name                 = "${each.value.team}-${each.value.env}-${local.suffix}"
  team_group_id        = azuread_group.groups["${each.value.team}_devs"].id
  admin_group_id       = azuread_group.groups["${each.value.team}_admins"].id
  superadmins_group_id = local.superadmins_aad_object_id
}


# Service Connections
# -------------------

module "service_connections" {
  for_each                 = module.arm_environments
  source                   = "./modules/azure-devops-service-connection"
  service_principal_id     = module.service_principals[each.key].principal_id
  service_principal_secret = module.service_principals[each.key].client_secret
  resource_group_name      = "${replace(each.key, "_", "-")}-${local.suffix}-rg"

  depends_on = [
    azuread_group.groups,
    module.arm_environments,
    module.service_principals
  ]
}
