# FRUITS

module "fruits_dev" {
  source      = "./modules/workspace"
  name        = "gov-fruits-dev"
}

module "fruits_prod" {
  source      = "./modules/workspace"
  name        = "gov-fruits-prod"
}

# VEGGIES

module "veggies_dev" {
  source      = "./modules/workspace"
  name        = "gov-veggies-dev"
}

module "veggies_prod" {
  source      = "./modules/workspace"
  name        = "gov-veggies-prod"
}

# SHARED SERVICES

module "governance_shared" {
  source      = "./modules/workspace"
  name        = "gov-shared-rg"
}

# OUTPUTS

output "shared" {
  value = {
    workspace           = module.governance_shared.workspace
    workspace_sp        = module.governance_shared.workspace_service_principal
    key_vault_reader_sp = module.governance_shared.key_vault_reader_service_principal
  }
}

output "fruits" {
  value = {
    dev  = {
      workspace           = module.fruits_dev.workspace
      workspace_sp        = module.fruits_dev.workspace_service_principal
      key_vault_reader_sp = module.fruits_dev.key_vault_reader_service_principal
    }
    prod  = {
      workspace           = module.fruits_prod.workspace
      workspace_sp        = module.fruits_prod.workspace_service_principal
      key_vault_reader_sp = module.fruits_prod.key_vault_reader_service_principal
    }
  }
}

output "veggies" {
  value = {
    dev  = {
      workspace           = module.veggies_dev.workspace
      workspace_sp        = module.veggies_dev.workspace_service_principal
      key_vault_reader_sp = module.veggies_dev.key_vault_reader_service_principal
    }
    prod  = {
      workspace           = module.veggies_prod.workspace
      workspace_sp        = module.veggies_prod.workspace_service_principal
      key_vault_reader_sp = module.veggies_prod.key_vault_reader_service_principal
    }
  }
}
