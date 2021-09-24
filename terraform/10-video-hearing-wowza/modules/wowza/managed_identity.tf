
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
