variable "ado_project_id" {
  description = "Azure DevOps Project ID"
  type        = string
}

# TODO: rename to devs_aad_id
variable "team_aad_id" {
  description = "AAD Group ID to receive 'Contributor' permissions"
  type        = string
}

variable "admin_aad_id" {
  description = "AAD Group ID to receive 'Owner' permissions"
  type        = string
}
