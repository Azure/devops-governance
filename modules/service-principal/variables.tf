# Input Variables
# ---------------

variable "name" {
  type        = string
  description = "Name for service principal"

  validation {
    condition     = length(var.name) < 35
    error_message = "Please keep service principal names to less than 35 characters."
  }
}

variable "tenant_id" {
  type        = string
  description = "Azure Active Directory Tenant ID"
  default     = "Current Client Tenant ID"
}

variable "password_lifetime" {
  type        = string
  description = "Lifetime of password in hours, e.g. '720h'. Defaults to 6 months. After password expires, credential needs to be refreshed (but not deleted)."
  default     = "4380h"
}

# Normalize Values
# ----------------

data "azurerm_client_config" "current" {}

locals {
  name      = lower(var.name)
  tenant_id = var.tenant_id == "" ? data.azurerm_client_config.current.tenant_id : var.tenant_id
}
