resource "azurerm_private_link_service" "wowza" {
  name = var.service_name

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.wowza.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name      = "primary"
    subnet_id = azurerm_subnet.wowza.id
    primary   = true
  }
  tags = var.tags
}

