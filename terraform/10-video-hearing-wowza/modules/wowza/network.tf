data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "peering_target" {
    provider = azurerm.peering_target
}

locals {
  dns_zone_name        = var.environment == "prod" ? "platform.hmcts.net" : "sandbox.platform.hmcts.net"
  peering_vnets        = ["hmcts-hub-sbox-int"] #var.environment != "prod" && var.environment != "stg" ? ["hmcts-hub-prod-int", "ukw-hub-prod-int"] : []
  peering_subscription = data.azurerm_subscription.peering_target.subscription_id #"ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
}

resource "azurerm_virtual_network" "wowza" {
  name          = var.service_name
  address_space = [var.address_space]

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location
  tags = var.tags
}

resource "azurerm_subnet" "wowza" {
  name                 = "wowza"
  resource_group_name  = azurerm_resource_group.wowza.name
  virtual_network_name = azurerm_virtual_network.wowza.name
  address_prefixes     = [var.address_space]

  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies = true
}

resource "azurerm_network_security_group" "wowza" {
  name = var.service_name

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  security_rule {
    name                       = "REST"
    priority                   = 1030
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8087"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RTMPS"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = var.tags
}

resource "azurerm_virtual_network_peering" "vh-to-hub" {
  provider = azurerm.peering_client
  for_each                     = toset(local.peering_vnets)

  name                         = each.value
  resource_group_name          = azurerm_resource_group.wowza.name
  virtual_network_name         = azurerm_virtual_network.wowza.name
  remote_virtual_network_id    = "/subscriptions/${local.peering_subscription}/resourceGroups/${each.value}/providers/Microsoft.Network/virtualNetworks/${each.value}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}

resource "azurerm_virtual_network_peering" "hub-to-vh" {
  provider = azurerm.peering_target
  for_each                     = toset(local.peering_vnets)

  name                         = azurerm_virtual_network.wowza.name
  resource_group_name          = each.value
  virtual_network_name         = each.value
  remote_virtual_network_id    = azurerm_virtual_network.wowza.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}