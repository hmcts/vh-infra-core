data "azurerm_resource_group" "vh-core-infra" {
  name = var.resource_group_name
}

resource "azurerm_app_configuration" "vh" {
  name                = var.resource_group_name
  resource_group_name = data.azurerm_resource_group.vh-core-infra.name
  location            = var.location

  sku = "free"
  tags = var.tags
}

data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "connectionstrings_appconfig" {
  name         = "connectionstrings--appconfig"
  value        = azurerm_app_configuration.vh.primary_write_key[0].connection_string
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type = "secret"
  tags = var.tags
}


