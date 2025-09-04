output "role_assignment_ids" {
  description = "Map of assignment keys to created role assignment IDs."
  value = merge(
    { for k, v in azurerm_synapse_role_assignment.workspace  : k => v.id },
    { for k, v in azurerm_synapse_role_assignment.spark_pool : k => v.id }
  )
}

output "workspace_assignments" {
  description = "Full objects for workspace-scoped assignments."
  value       = azurerm_synapse_role_assignment.workspace
}

output "spark_pool_assignments" {
  description = "Full objects for spark-pool-scoped assignments."
  value       = azurerm_synapse_role_assignment.spark_pool
}
