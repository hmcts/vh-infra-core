data "azurerm_client_config" "current" {
}

locals {
  dns_zone_name = var.environment == "prod" ? "platform.hmcts.net" : "sandbox.platform.hmcts.net"
  ip_list       = [for vm in azurerm_linux_virtual_machine.wowza : vm.private_ip_address]
  ip_csv        = join(",", local.ip_list)
  aks_address = {
    prod = "10.144.0.0/18"
    stg  = "10.148.0.0/18"
    dev  = "10.145.0.0/18"
    test = "10.51.64.0/18"
    sbox = "10.140.0.0/18"
    ithc = "10.143.0.0/18"
  }
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
    name                       = "DenyAllAzureLoadBalancerInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyAllVnetInbound"
    priority                   = 4095
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "App-Rules"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "8087"]
    source_address_prefix      = "*" #lookup(local.aks_address, var.environment, "*")
    destination_address_prefix = var.address_space
  }

  security_rule {
    name                       = "Azure-LB-Probe"
    priority                   = 1050
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "443", "8087"]
    destination_address_prefix = var.address_space
  }

  security_rule {
    name                       = "AllowWowzaSSH"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22"]
    source_address_prefixes    = [var.address_space]
    destination_address_prefix = var.address_space
  }

  tags = var.tags

  depends_on = [
    azurerm_linux_virtual_machine.wowza
  ]
}