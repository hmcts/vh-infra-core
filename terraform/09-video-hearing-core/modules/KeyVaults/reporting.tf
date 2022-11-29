data "azurerm_resource_group" "managed-identities-rg" {
  name = "managed-identities-${var.environment}-rg"
}

resource "azurerm_user_assigned_identity" "adf_mi" {
  name                = "vh-adf-${var.environment}-mi"
  resource_group_name = data.azurerm_resource_group.managed-identities-rg.name
  location            = data.azurerm_resource_group.managed-identities-rg.location
  tags                = local.common_tags
}


resource "azurerm_key_vault_access_policy" "kvaccess" {
  key_vault_id = data.azurerm_key_vault.infra_core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.adf_mi.principal_id

  key_permissions = [
    "Get", "List",
  ]

  secret_permissions = [
    "Get", "List",
  ]

}