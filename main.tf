# Note: all variables included here for easier understanding/learning

# Suffix
# ------
# Some Azure resources, e.g. storage accounts must have globally
# unique names. Use a suffix to avoid automation errors.

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

# List of Workspaces
# ------------------
# This map defines our workspaces. The keys can be referenced in outputs,
# e.g. module.workspace["gov_shared"]. Suffixes are appended later.

variable "workspaces" {
  type = map(string)
  default = {
    fruits_dev   = "fruits-dev"
    fruits_prod  = "fruits-prod"
    veggies_dev  = "veggies-dev"
    veggies_prod = "veggies-prod"
    gov_shared   = "gov-shared"
  }
}

# Module: Create Workspaces
# -------------------------
# Finally create workspaces, which in this demo are resource groups.
# Using `*` automatically output _all_  module outputs.

module "workspace" {
  for_each = var.workspaces
  source   = "./modules/workspace"
  name     = "${each.value}-${random_string.suffix.result}"
}

output "workspaces" {
  value = module.workspace[*]
}
