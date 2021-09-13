resource "azurerm_lb" "wowza" {
  name = var.service_name

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  sku = "Standard"

  frontend_ip_configuration {
    name      = "wowza"
    subnet_id = azurerm_subnet.wowza.id
  }
  tags = var.tags
}

resource "azurerm_lb_probe" "wowza_rtmps" {
  resource_group_name = azurerm_resource_group.wowza.name
  loadbalancer_id     = azurerm_lb.wowza.id
  name                = "rtmps-running-probe"
  port                = 443
}

resource "azurerm_lb_probe" "wowza_rest" {
  resource_group_name = azurerm_resource_group.wowza.name
  loadbalancer_id     = azurerm_lb.wowza.id
  name                = "rest-running-probe"
  port                = 8087
}

resource "azurerm_lb_rule" "wowza" {
  resource_group_name            = azurerm_resource_group.wowza.name
  loadbalancer_id                = azurerm_lb.wowza.id
  name                           = "RTMPS-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "wowza"
  probe_id                       = azurerm_lb_probe.wowza_rtmps.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.wowza.id
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 30
}

resource "azurerm_lb_rule" "wowza_rest" {
  count = var.wowza_instance_count

  resource_group_name            = azurerm_resource_group.wowza.name
  loadbalancer_id                = azurerm_lb.wowza.id
  name                           = "REST-${count.index}"
  protocol                       = "Tcp"
  frontend_port                  = 8090 + count.index
  backend_port                   = 8087
  frontend_ip_configuration_name = "wowza"
  probe_id                       = azurerm_lb_probe.wowza_rest.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.wowza_vm[count.index].id
}

resource "azurerm_lb_backend_address_pool" "wowza" {
  resource_group_name = azurerm_resource_group.wowza.name
  loadbalancer_id     = azurerm_lb.wowza.id
  name                = "wowza"
}

resource "azurerm_lb_backend_address_pool" "wowza_vm" {
  count = var.wowza_instance_count

  resource_group_name = azurerm_resource_group.wowza.name
  loadbalancer_id     = azurerm_lb.wowza.id
  name                = "${var.service_name}-${count.index}"
}
