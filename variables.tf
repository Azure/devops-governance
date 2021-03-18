# Superadmins
# -----------

variable "superadmins_aad_object_id" {
  type        = string
  description = "Object ID of the AAD group for super admins, used to apply key vault access policies, so both humans and super privileged automation service principal can manage Key Vault resources (from outside Terraform)."
}


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

variable "groups" {
  type = map(string)
  default = {
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
}


# Azure DevOps
# ------------

variable "projects" {
  type = map(map(string))
  default = {
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
}


# Workspaces
# ----------
# This map defines our workspaces. The keys can be referenced in outputs,
# e.g. module.workspace["gov_shared"]. Suffixes are appended later.

variable "environments" {
  type = map(map(string))

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
