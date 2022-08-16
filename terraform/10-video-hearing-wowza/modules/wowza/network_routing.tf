resource "azurerm_route_table" "wowza" {
  name                          = var.service_name
  location                      = azurerm_resource_group.wowza.location
  resource_group_name           = azurerm_resource_group.wowza.name
  disable_bgp_route_propagation = false
  tags                          = var.tags

  dynamic "route" {
    for_each = var.route_table
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix == "AKS" ? lookup(local.aks_address, var.environment, "*") : route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "wowza" {
  subnet_id      = azurerm_subnet.wowza.id
  route_table_id = azurerm_route_table.wowza.id
}

resource "azurerm_route" "aks_route_rule_stg" {
  count    = var.environment != "prod" ? 1 : 0
  provider = azurerm.networking_staging

  name                   = var.service_name
  resource_group_name    = "ss-stg-network-rg"
  route_table_name       = "aks-stg-appgw-route-table"
  address_prefix         = var.address_space
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.11.8.36"
}
resource "azurerm_route" "aks_route_rule_prod" {
  count    = var.environment == "prod" ? 1 : 0
  provider = azurerm.networking_prod

  name                   = var.service_name
  resource_group_name    = "ss-prod-network-rg"
  route_table_name       = "aks-prod-route-table"
  address_prefix         = var.address_space
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.11.8.36"
}

