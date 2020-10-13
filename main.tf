# Note: all variables included here for easier understanding/learning

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
}


# Azure AD Groups
# ---------------
# Workspaces generally have 2 groups of actors, general
# team members who are granted "Contributor" permissions
# and admins who are granted "Owner" permissions.

variable "teams" {
  type = map(string)
  default = {
    fruits         = "fruits"
    fruits_admins  = "fruits-admins"
    veggies_admins = "veggies-admins"
    veggies        = "veggies"
    infra          = "infra"
    infra_admins   = "infra"
  }
}

resource "azuread_group" "groups" {
  for_each                = var.teams
  name                    = "demo-${each.value}-${local.suffix}"
  prevent_duplicate_names = true
}


# Workspaces
# ----------
# This map defines our workspaces. The keys can be referenced in outputs,
# e.g. module.workspace["gov_shared"]. Suffixes are appended later.

variable "environments" {
  type    = map(map(string))

  default = {
    fru_dev = {
      env  = "dev"
      team = "fruits"
    }

    fru_prod = {
      env  = "prod"
      team = "fruits"
    }

    veg_dev = {
      env  = "dev"
      team = "veggies"
    }

    veg_prod = {
      env  = "prod"
      team = "veggies"
    }

    shared = {
      env  = "shared"
      team = "infra"
    }
  }
}

module "workspace" {
  for_each       = var.environments
  source         = "./modules/workspace"
  name           = "${each.value.team}-${each.value.env}-${local.suffix}"
  team_group_id  = azuread_group.groups["${each.value.team}"].id
  admin_group_id = azuread_group.groups["${each.value.team}_admins"].id
}


# Outputs
# -------

output "workspaces" {
  value = module.workspace[*]
}

output "aad_groups" {
  value = azuread_group.groups[*]
}