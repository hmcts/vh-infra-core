resource "azurerm_signalr_service" "vh" {
  name                = var.resource_prefix
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = local.sku.name
    capacity = local.sku.capacity
  }
  tags = var.tags
}

