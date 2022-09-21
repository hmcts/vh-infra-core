
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
  scope                = module.wowza_recordings.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.wowza_storage.principal_id
}

resource "azurerm_role_assignment" "wowza_storage_vh_mi" {
  scope                = module.wowza_recordings.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_user_assigned_identity.vh_mi.principal_id
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

#-----------------------
# VM Cert Access
#-----------------------

resource "azurerm_user_assigned_identity" "wowza_cert" {
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  name = "vh-wowza-cert-${var.environment}-mi"
  tags = var.tags
}
data "azurerm_key_vault" "acmekv" {
  name                = "acmedtssds${var.environment}"
  resource_group_name = "sds-platform-${var.environment}-rg"
}
resource "azurerm_role_assignment" "kv_access" {
  scope                = data.azurerm_key_vault.acmekv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.wowza_cert.principal_id
}