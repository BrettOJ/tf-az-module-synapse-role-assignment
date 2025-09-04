variable "synapse_workspace_id" {
  description = "Resource ID of the Synapse Workspace."
  type        = string
}

variable "assignments" {
  description = <<-EOT
  Map of role assignments keyed by a friendly name.
  Each value:
    - role_name:   Built-in Synapse RBAC role name (e.g., 'Synapse Administrator', 'Synapse SQL Administrator', 'Synapse Contributor', etc.)
    - principal_id: Object ID of the AAD user, group, service principal, or managed identity
    - synapse_spark_pool_id (optional): If set, assignment is scoped to this Spark pool; otherwise it's workspace-scoped.
  EOT
  type = map(object({
    role_name             = string
    principal_id          = string
    synapse_spark_pool_id = optional(string)
  }))

  validation {
    condition     = length(var.assignments) >= 1
    error_message = "Provide at least one assignment."
  }
}

variable "timeouts" {
  description = "Optional custom timeouts for create/read/delete."
  type = object({
    create = optional(string)
    read   = optional(string)
    delete = optional(string)
  })
  default = null
}
