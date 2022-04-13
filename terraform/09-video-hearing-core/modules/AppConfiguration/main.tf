
resource "azurerm_app_configuration" "vh" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku  = "free"
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
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}


