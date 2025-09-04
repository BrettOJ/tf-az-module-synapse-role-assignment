terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = ">= 3.100.0" }
    azuread = { source = "hashicorp/azuread",  version = ">= 2.50.0" }
  }
}

#provider "azurerm" { features {} }
provider "azuread" {}

# -----------------------------------------------------------------------------------
# Look up existing workspace & (optionally) a Spark pool
# -----------------------------------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_synapse_workspace" "ws" {
  name                = var.workspace_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Optional: scope some roles to a specific Spark pool
data "azurerm_synapse_spark_pool" "small" {
  name                 = var.spark_pool_name # e.g. "spark3p3-small"
  synapse_workspace_id = data.azurerm_synapse_workspace.ws.id
}

# -----------------------------------------------------------------------------------
# Look up AAD principals you want to assign roles to
# (swap for users or service principals as needed)
# -----------------------------------------------------------------------------------
data "azuread_group" "synapse_admins" {
  display_name = var.admins_group_display_name # e.g. "SG-Synapse-Admins"
}

data "azuread_group" "engineers" {
  display_name = var.engineers_group_display_name # e.g. "SG-Data-Engineers"
}

# Example: current caller (service principal) as principal
data "azurerm_client_config" "current" {}

# -----------------------------------------------------------------------------------
# Call the module
# -----------------------------------------------------------------------------------
module "synapse_rbac" {
  source               = "../"
  synapse_workspace_id = data.azurerm_synapse_workspace.ws.id

  # Key each desired assignment with a friendly name
  assignments = {
    synapse_admins = {
      role_name    = "Synapse Administrator"
      principal_id = data.azuread_group.synapse_admins.object_id
    }

    sql_admin_current_sp = {
      role_name    = "Synapse SQL Administrator"
      principal_id = data.azurerm_client_config.current.object_id
    }

    spark_compute_operator = {
      role_name             = "Synapse Compute Operator"
      principal_id          = data.azuread_group.engineers.object_id
      synapse_spark_pool_id = data.azurerm_synapse_spark_pool.small.id
    }
  }

  # Optional: extend timeouts if your workspace is freshly created / restricted
  timeouts = {
    create = "30m"
    read   = "5m"
    delete = "30m"
  }
}

output "created_assignments" {
  value = module.synapse_rbac.role_assignment_ids
}
