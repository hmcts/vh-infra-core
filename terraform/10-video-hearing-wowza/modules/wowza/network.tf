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

  security_rule {
    name                       = "AllowPexip"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "8087"]
    source_address_prefixes    = ["81.133.255.164", "34.89.28.171", "35.230.133.33", "34.105.222.224", "34.105.225.83", "35.197.253.33", "34.105.233.162", "35.246.64.24", "81.109.71.47", "34.89.39.181", "35.242.179.109", "35.242.165.45", "35.197.196.46", "35.189.94.75", "34.89.124.153", "34.105.159.151", "34.89.79.120", "35.246.119.253", "35.246.31.7", "35.197.222.76", "35.197.243.189", "35.246.78.140", "34.89.85.40", "35.242.137.0", "34.105.132.247", "35.246.9.51", "35.197.233.103", "34.105.241.54", "35.230.142.100", "35.242.188.19", "34.89.47.135", "35.246.83.177", "35.189.114.248", "35.246.125.146", "35.246.61.112", "34.89.20.125", "35.189.116.218", "34.105.186.145", "34.89.50.164", "35.246.33.64", "34.89.67.244", "35.197.192.122", "35.189.100.191", "35.246.20.226", "34.89.9.141", "35.242.128.122", "34.105.132.33", "35.246.42.154", "35.197.225.12", "35.242.169.216", "35.234.136.134", "34.89.42.12", "35.189.65.193", "34.89.47.84", "35.246.46.20", "34.105.148.74", "34.89.94.255", "35.234.154.137", "34.105.220.46", "34.105.191.88", "35.230.154.5", "35.230.150.118", "35.242.161.144", "35.242.138.161", "35.230.150.72", "35.242.182.90", "35.189.126.139", "34.105.175.144", "34.105.180.47", "34.89.24.209", "34.105.185.156", "35.197.206.63", "34.89.10.36", "35.246.108.50", "35.246.55.21", "34.105.199.202", "35.197.219.228", "35.189.85.234", "34.89.90.252", "34.105.254.1", "34.89.16.12", "34.105.201.194", "34.89.55.45", "35.246.113.78", "35.234.156.166", "34.105.191.37", "34.105.201.126", "34.105.181.204", "35.189.85.128", "35.246.120.206", "35.189.82.242", "34.105.229.172", "35.230.134.63", "35.189.71.128", "34.89.112.200", "35.230.139.59", "35.246.58.8", "34.89.57.150", "34.89.112.7", "34.77.152.87", "35.189.76.6", "34.89.26.193", "34.105.156.138", "35.197.245.49", "34.105.158.61", "34.89.47.123", "34.105.130.201", "35.197.226.208", "34.105.128.1", "35.234.156.229", "35.246.44.168", "35.246.88.27", "34.105.137.114", "35.197.252.192", "34.105.204.202", "34.105.172.197", "35.234.145.136", "34.105.164.16", "35.189.103.174", "35.234.144.216", "35.246.9.25", "34.105.220.131", "35.189.122.97", "34.89.124.198", "35.246.26.18", "34.89.58.234", "35.246.108.205", "34.89.9.21"]
    destination_address_prefix = var.address_space
  }

  security_rule {
    name                       = "AllowAKSInbound"
    priority                   = 1030
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "8087"]
    source_address_prefix      = lookup(local.aks_address, var.environment, "*")
    destination_address_prefix = var.address_space
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerProbes"
    priority                   = 1050
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "443", "8087"]
    destination_address_prefix = var.address_space
  }

  tags = var.tags

  depends_on = [
    azurerm_linux_virtual_machine.wowza
  ]
}