data "azurerm_resource_group" "vh-infra-core" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "ss_vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
}

data "azurerm_subnet" "ss_subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.vh-infra-core.name
}

resource "azurerm_private_endpoint" "vh_endpoint" {
  for_each            = var.resources  

  name                = "vh-endpoint-${var.environment}"
  location            = data.azurerm_resource_group.vh-infra-core.location
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
  subnet_id           = data.azurerm_subnet.ss_subnet.id

  private_service_connection {
    name                                = "vh-${var.environment}-aksserviceconnection"
    private_connection_resource_alias   = lookup(each.value, "id")
    is_manual_connection                = false
  }
}