resource "azurerm_network_interface" "wowza" {
  count = var.wowza_instance_count

  name = "${var.service_name}_${count.index + 1}"

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  ip_configuration {
    name                          = "wowzaConfiguration"
    subnet_id                     = azurerm_subnet.wowza.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "wowza" {
  count = var.wowza_instance_count

  network_interface_id      = azurerm_network_interface.wowza[count.index].id
  network_security_group_id = azurerm_network_security_group.wowza.id
}

resource "azurerm_network_interface_backend_address_pool_association" "wowza" {
  count = var.wowza_instance_count

  network_interface_id    = azurerm_network_interface.wowza[count.index].id
  ip_configuration_name   = "wowzaConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.wowza.id
}

resource "azurerm_network_interface_backend_address_pool_association" "wowza_vm" {
  count = var.wowza_instance_count

  network_interface_id    = azurerm_network_interface.wowza[count.index].id
  ip_configuration_name   = "wowzaConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.wowza_vm[count.index].id
}

resource "azurerm_network_interface_backend_address_pool_association" "wowza-public" {
  count = var.wowza_instance_count

  network_interface_id    = azurerm_network_interface.wowza[count.index].id
  ip_configuration_name   = "wowzaConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.wowza-public.id
}

# resource "azurerm_network_interface_backend_address_pool_association" "wowza_vm-public" {
#   count = var.wowza_instance_count

#   network_interface_id    = azurerm_network_interface.wowza[count.index].id
#   ip_configuration_name   = "wowzaConfiguration"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.wowza_vm-public[count.index].id
# }
