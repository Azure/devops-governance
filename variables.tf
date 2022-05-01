# Superadmins AAD
variable "superadmins_aad_object_id" {
  type        = string
  description = "Object ID of the AAD group for super admins, used to apply key vault access policies, so both humans and super privileged automation service principal can manage Key Vault resources (from outside Terraform). Defaults to object ID of current client."
  default     = ""
}

# Service Principal Owners
variable "application_owners_ids" {
  type        = list(string)
  description = "A set of object IDs of principals that will be granted ownership of the application (service principal). Supported object types are users or service principals. It is best practice to specify one or more owners, incl. the principal used to execute Terraform"
  default     = []
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

variable "tags" {
  description = "Tags to apply to Azure Resources"
  type        = map(string)
  default = {
    public = "true"
    demo   = "e2e-governance"
    iac    = "terraform"
  }
}
