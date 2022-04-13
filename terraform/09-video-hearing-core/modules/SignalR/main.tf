data "azurerm_resource_group" "vh-infra-core" {
  name = var.resource_group_name
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

