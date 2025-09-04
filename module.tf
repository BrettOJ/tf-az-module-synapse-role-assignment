
locals {
  # Split assignments by scope so we only set spark_pool_id when present.
  workspace_scope = {
    for k, v in var.assignments : k => v
    if try(v.synapse_spark_pool_id, null) == null
  }

  spark_pool_scope = {
    for k, v in var.assignments : k => v
    if try(v.synapse_spark_pool_id, null) != null
  }
}

# Workspace-scoped role assignments
resource "azurerm_synapse_role_assignment" "workspace" {
  for_each = local.workspace_scope

  synapse_workspace_id = var.synapse_workspace_id
  role_name            = each.value.role_name
  principal_id         = each.value.principal_id

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      read   = try(timeouts.value.read,   null)
      delete = try(timeouts.value.delete, null)
    }
  }
}

# Spark-pool-scoped role assignments
resource "azurerm_synapse_role_assignment" "spark_pool" {
  for_each = local.spark_pool_scope

  synapse_workspace_id  = var.synapse_workspace_id
  synapse_spark_pool_id = each.value.synapse_spark_pool_id
  role_name             = each.value.role_name
  principal_id          = each.value.principal_id

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      read   = try(timeouts.value.read,   null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
