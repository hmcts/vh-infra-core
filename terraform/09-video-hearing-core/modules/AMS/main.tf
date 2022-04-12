data "azurerm_resource_group" "vh-infra-core" {
  name = var.resource_group_name
}

resource "azurerm_media_services_account" "vh-infra-core" {
  name                = replace(var.resource_prefix, "-", "")
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
  location            = data.azurerm_resource_group.vh-infra-core.location

  storage_account {
    id         = var.storage_account_id
    is_primary = true
  }
  tags = var.tags
}
