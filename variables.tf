# Superadmins AAD
variable "superadmins_aad_object_id" {
  type        = string
  description = "Object ID of the AAD group for super admins, used to apply key vault access policies, so both humans and super privileged automation service principal can manage Key Vault resources (from outside Terraform). Defaults to object ID of current client."
  default     = ""
}

# AAD Groups
variable "groups" {
  type = map(string)
}

# Azure DevOps
variable "projects" {
  type = map(map(string))
}

# Workspaces / Environments
variable "environments" {
  type = map(map(string))
}
