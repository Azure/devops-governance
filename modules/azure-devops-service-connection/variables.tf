variable "service_principal_id" {
  type        = string
  description = "ID of Service Principal scoped to workspace/environment. The display name of this service principal uses `fruits-dev-XXXX-rg-sp` format, where `X` is a random character."
}

variable "key_vault_name" {
  type        = string
  description = "Name of Key Vault of this workspace, e.g. `fruits-dev-XXXX-kv`, where `X` is a random character."
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group of this workspace, e.g. `fruits-dev-XXXX-rg`, where `X` is a random character."
}

locals {
  sp_secret_name  = "workspace-sp-secret"
  connection_name = "${var.resource_group_name}-connection"
  project_name    = split("-", var.resource_group_name)[0] == "infra" ? "central-it" : "project-${split("-", var.resource_group_name)[0]}"
}

# Note: ADO project names are determined based on Resource Group name patterns:
#
# - fruits-dev-u6t7-rg
# - veggies-prod-u6t7-rg
# - infra-shared-u6t7-rg (breaks convetion)
