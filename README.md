# tf-az-module-synapse-role-assignment
Terrform Module to assign an Azure Synapse RBAC role 


---
created: 2025-09-04T13:39:17 (UTC +08:00)
tags: []
source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment
author: 
---

# azurerm_synapse_role_assignment | Resources | hashicorp/azurerm | Terraform | Terraform Registry

> ## Excerpt
> Manages a Synapse Role Assignment.

---
Manages a Synapse Role Assignment.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#example-usage)

```hcl
resource "azurerm_resource_group" "example" { name = "example-resources" location = "West Europe" } resource "azurerm_storage_account" "example" { name = "examplestorageacc" resource_group_name = azurerm_resource_group.example.name location = azurerm_resource_group.example.location account_tier = "Standard" account_replication_type = "LRS" account_kind = "StorageV2" is_hns_enabled = "true" } resource "azurerm_storage_data_lake_gen2_filesystem" "example" { name = "example" storage_account_id = azurerm_storage_account.example.id } resource "azurerm_synapse_workspace" "example" { name = "example" resource_group_name = azurerm_resource_group.example.name location = azurerm_resource_group.example.location storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id sql_administrator_login = "sqladminuser" sql_administrator_login_password = "H@Sh1CoR3!" identity { type = "SystemAssigned" } } resource "azurerm_synapse_firewall_rule" "example" { name = "AllowAll" synapse_workspace_id = azurerm_synapse_workspace.example.id start_ip_address = "0.0.0.0" end_ip_address = "255.255.255.255" } data "azurerm_client_config" "current" {} resource "azurerm_synapse_role_assignment" "example" { synapse_workspace_id = azurerm_synapse_workspace.example.id role_name = "Synapse SQL Administrator" principal_id = data.azurerm_client_config.current.object_id depends_on = [azurerm_synapse_firewall_rule.example] }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#argument-reference)

The following arguments are supported:

-   [`synapse_workspace_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#synapse_workspace_id-1) - (Optional) The Synapse Workspace which the Synapse Role Assignment applies to. Changing this forces a new resource to be created.
    
-   [`synapse_spark_pool_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#synapse_spark_pool_id-1) - (Optional) The Synapse Spark Pool which the Synapse Role Assignment applies to. Changing this forces a new resource to be created.
    

-   [`role_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#role_name-1) - (Required) The Role Name of the Synapse Built-In Role. Possible values are `Apache Spark Administrator`, `Synapse Administrator`, `Synapse Artifact Publisher`, `Synapse Artifact User`, `Synapse Compute Operator`, `Synapse Contributor`, `Synapse Credential User`, `Synapse Linked Data Manager`, `Synapse Monitoring Operator`, `Synapse SQL Administrator` and `Synapse User`. Changing this forces a new resource to be created.

-   [`principal_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#principal_id-1) - (Required) The ID of the Principal (User, Group or Service Principal) to assign the Synapse Role Definition to. Changing this forces a new resource to be created.
    
-   [`principal_type`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#principal_type-1) - (Optional) The Type of the Principal. One of `User`, `Group` or `ServicePrincipal`. Changing this forces a new resource to be created.
    

## [Attributes Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#attributes-reference)

In addition to the Arguments listed above - the following Attributes are exported:

-   [`id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#id-1) - The Synapse Role Assignment ID.

## [Timeouts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#timeouts)

The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:

-   [`create`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#create-1) - (Defaults to 30 minutes) Used when creating the Synapse Role Assignment.
-   [`read`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#read-1) - (Defaults to 5 minutes) Used when retrieving the Synapse Role Assignment.
-   [`delete`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#delete-1) - (Defaults to 30 minutes) Used when deleting the Synapse Role Assignment.

## [Import](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment#import)

Synapse Role Assignment can be imported using the `resource id`, e.g.

```shell
terraform import azurerm_synapse_role_assignment.example "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/group1/providers/Microsoft.Synapse/workspaces/workspace1|000000000000"
```

