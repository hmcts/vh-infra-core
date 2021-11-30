data "azurerm_resource_group" "vh-infra-core" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_endpoint" "vh_endpoint" {
  for_each            = var.resources

  name                = "vh-endpoint-${var.environment}"
  location            = data.azurerm_resource_group.vh-infra-core.location
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                                = "vh-${var.environment}-aksserviceconnection"
    private_connection_resource_id   = lookup(each.value, "resource_id")
    is_manual_connection                = false
  }
}