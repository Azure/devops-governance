variable "name" {
  type        = string
  description = "Base name of your workspace that will be used in resource names. Please use lowercase with dashes."


  validation {
    condition     = length(var.name) < 20
    error_message = "Name must be less than 20 characters."
  }
}

variable "location" {
  type        = string
  description = "Azure Region for resources. Defaults to Europe West."
  default     = "westeurope"
}

variable "team_group_id" {
  description = "AAD Group ID to receive 'Contributor' permissions"
  type        = string
}

variable "admin_group_id" {
  description = "AAD Group ID to receive 'Owner' permissions"
  type        = string
}

variable "superadmins_group_id" {
  type        = string
  description = "Required: object ID of the AAD group for super admins, used to apply key vault access policies."
}

variable "client_tenant_id" {
  description = "AAD Tenant ID for Azure Resource Manager (ARM) client. Defaults to current session."
  type        = string
  default     = ""
}

variable "client_object_id" {
  description = "Object ID for Azure Resource Manager (ARM) client. Defaults to current session."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to Azure Resources"
  type    = map(string)
  default = {
    demo   = "governance"
    devops = "true"
    oss    = "terraform"
    public = "true"
  }
}

# Variables - Normalized

data "azurerm_client_config" "current" {}

locals {
  name             = lower(var.name)
  name_squished    = replace(local.name, "-", "")
  client_tenant_id = var.client_tenant_id == "" ? data.azurerm_client_config.current.tenant_id : var.client_tenant_id
  client_object_id = var.client_object_id == "" ? data.azurerm_client_config.current.object_id : var.client_object_id
}
