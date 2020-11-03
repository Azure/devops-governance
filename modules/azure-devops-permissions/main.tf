# Azure DevOps Groups
# -------------------
# To add AAD groups to existing project roles:
#
# 1) Create new ADO group
# 2) Get Reference to existing group, e.g. Contribtors in ADO Project
# 3) Add ADO group (which references AAD group) to "Contributors" from above

locals {
  team_role  = "Contributors"
  admin_role = "Project Administrators"
}

# Contributors

resource "azuredevops_group" "team_group" {
  origin_id = var.team_aad_id
}

data "azuredevops_group" "contributors" {
  project_id = var.ado_project_id
  name       = local.team_role
}

resource "azuredevops_group_membership" "team" {
  group = data.azuredevops_group.contributors.descriptor
  members = [
    azuredevops_group.team_group.descriptor
  ]
}

# Administrators

resource "azuredevops_group" "admins_group" {
  origin_id = var.admin_aad_id
}

data "azuredevops_group" "admins" {
  project_id = var.ado_project_id
  name       = local.admin_role
}

resource "azuredevops_group_membership" "admins" {
  group = data.azuredevops_group.admins.descriptor
  members = [
    azuredevops_group.team_group.descriptor
  ]
}
