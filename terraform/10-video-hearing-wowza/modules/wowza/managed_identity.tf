
#--------------------------------------------------------------
# VH - MI Creation
#--------------------------------------------------------------

data "azurerm_subscription" "current" {
}

resource "azurerm_user_assigned_identity" "wowza_storage" {
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  name = "wowza-storage-${var.environment}"
  tags = var.tags
}

output "wowza-storage-msi" {
  value = azurerm_user_assigned_identity.wowza_storage
}

resource "azurerm_role_assignment" "wowza_storage_access" {
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/vh-infra-wowza-${var.environment}/providers/Microsoft.Storage/storageAccounts/vhinfrawowza${var.environment}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.wowza_storage.principal_id
}

# Add Managed Identity clientID to infra KeyVault
resource "azurerm_key_vault_secret" "wowza-mi-clientid" {
  name         = "wowzaconfiguration--managedidentityclientid"
  value        = azurerm_user_assigned_identity.wowza_storage.client_id
  key_vault_id = var.key_vault_id
}

#-----------------------
# VM Automation account
#-----------------------

# Create a user-assigned managed identity
resource "azurerm_user_assigned_identity" "wowza-automation-account-mi" {
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  name = "wowza-automation-mi-${var.environment}"
  tags = var.tags
}

# Create a custom, limited role for our managed identity
resource "azurerm_role_definition" "virtual-machine-control" {
  name        = "Virtual-Machine-Control-${var.environment}"
  scope       = azurerm_resource_group.wowza.id #  our resource group
  description = "Custom Role for controlling virtual machines"
  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/deallocate/action",
    ]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_resource_group.wowza.id,
  ]
}

resource "azurerm_role_assignment" "wowza-auto-acct-mi-role" {
  scope = azurerm_resource_group.wowza.id ##### CHECK ME

  # using our custom role
  #role_definition_name = azurerm_role_definition.virtual-machine-control.name
  role_definition_id = azurerm_role_definition.virtual-machine-control.role_definition_resource_id
  # principal_id is the principal_id of the user assigned system managed identity we just created
  principal_id = azurerm_user_assigned_identity.wowza-automation-account-mi.principal_id

  # This depends_on must be here or the terraform destroy will fail
  depends_on = [
    azurerm_role_definition.virtual-machine-control
  ]

}