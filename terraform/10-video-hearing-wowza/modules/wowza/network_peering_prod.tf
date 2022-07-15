locals {
  peering_prod_vnets        = var.environment == "prod" || var.environment == "stg" ? ["hmcts-hub-prod-int", "ukw-hub-prod-int"] : []
  peering_prod_subscription = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
}

resource "azurerm_virtual_network_peering" "vnet_to_uks_prod_hub" {
  provider                  = azurerm.peering_client
  for_each                  = toset(local.peering_prod_vnets)
  name                      = each.value
  resource_group_name       = azurerm_resource_group.wowza.name
  virtual_network_name      = azurerm_virtual_network.wowza.name
  remote_virtual_network_id = "/subscriptions/${local.peering_prod_subscription}/resourceGroups/${each.value}/providers/Microsoft.Network/virtualNetworks/${each.value}"
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "uks_prod_hub_to_vnet" {
  provider                  = azurerm.peering_target_prod
  for_each                  = toset(local.peering_prod_vnets)
  name                      = azurerm_virtual_network.wowza.name
  resource_group_name       = each.value
  virtual_network_name      = each.value
  remote_virtual_network_id = azurerm_virtual_network.wowza.id
  allow_forwarded_traffic   = true
}
 