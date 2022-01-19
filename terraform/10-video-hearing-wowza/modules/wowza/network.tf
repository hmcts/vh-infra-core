data "azurerm_virtual_network" "hub" {
  name = "hmcts-hub-sbox-int"
  resource_group_name = "hmcts-hub-sbox-int"
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

  name                         = var.initiator_peer_name
  resource_group_name          = azurerm_resource_group.wowza.name
  virtual_network_name         = azurerm_virtual_network.wowza.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}

resource "azurerm_virtual_network_peering" "hub-to-vh" {
  provider = azurerm.target

  name                         = data.azurerm_virtual_network.hub.name
  resource_group_name          = data.azurerm_virtual_network.hub.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.hub.id
  remote_virtual_network_id    = azurerm_resource_group.wowza.name
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}