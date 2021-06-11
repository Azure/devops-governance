variable "resource_group_name" {
  type        = string
  description = "Name of resource group of this workspace the service principal is scoped to."
}

variable "service_principal_id" {
  type        = string
  description = "Client ID for Service Principal"
}

variable "service_principal_secret" {
  type        = string
  description = "Client Secret for Service Principal"
  sensitive   = true
}
