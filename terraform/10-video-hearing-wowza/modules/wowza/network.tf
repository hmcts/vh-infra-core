data "azurerm_client_config" "current" {
}

locals {
  dns_zone_name = var.environment == "prod" ? "platform.hmcts.net" : "sandbox.platform.hmcts.net"
}

resource "azurerm_virtual_network" "wowza" {
  name          = var.service_name
  address_space = [var.address_space]

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location
  tags                = var.tags
}

resource "azurerm_subnet" "wowza" {
  name                 = "wowza"
  resource_group_name  = azurerm_resource_group.wowza.name
  virtual_network_name = azurerm_virtual_network.wowza.name
  address_prefixes     = [var.address_space]

  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}


resource "azurerm_subnet_network_security_group_association" "wowza" {
  subnet_id                 = azurerm_subnet.wowza.id
  network_security_group_id = azurerm_network_security_group.wowza.id
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
