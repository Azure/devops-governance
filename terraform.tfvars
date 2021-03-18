# Azure AD Groups
# ---------------
# Workspaces generally have 2 groups of actors, general
# team members who are granted "Contributor" permissions
# and admins who are granted "Owner" permissions.

groups = {
  fruits         = "fruits-all"
  fruits_devs    = "fruits-devs"
  fruits_admins  = "fruits-admins"
  veggies        = "veggies-all"
  veggies_devs   = "veggies-devs"
  veggies_admins = "veggies-admins"
  infra          = "infra"
  infra_devs     = "infra-dev"
  infra_admins   = "infra-admins"
}

# Azure DevOps Projects
# ---------------------

projects = {
  proj_fruits = {
    name        = "project-fruits"
    description = "Demo using AAD groups"
    team        = "fruits"
  }

  proj_veggies = {
    name        = "project-veggies"
    description = "Demo using AAD groups"
    team        = "veggies"
  }

  proj_infra = {
    name        = "central-it"
    description = "Central IT managed stuff"
    team        = "infra"
  }
}

# Workspaces / Environments
# -------------------------
# The keys can be referenced in outputs,
# e.g. module.workspace["gov_shared"]. Suffixes are appended later.

environments = {
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
