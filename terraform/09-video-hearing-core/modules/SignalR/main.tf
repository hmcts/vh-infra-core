data "azurerm_resource_group" "vh-infra-core" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_signalr_service" "vh" {
  name                = var.resource_prefix
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
  location            = data.azurerm_resource_group.vh-infra-core.location

  sku {
    name     = local.sku.name
    capacity = local.sku.capacity
  }
  tags = var.tags
}

resource "azurerm_key_vault_secret" "signalr_connection_str" {
   name         = "connectionstrings--signalr"
   value        = azurerm_signalr_service.vh.primary_connection_string
   key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
   # FromTFSec
  content_type = "secret"
   tags = var.tags
}

