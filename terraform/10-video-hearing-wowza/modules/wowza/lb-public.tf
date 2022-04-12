resource "azurerm_public_ip" "wowza" {
  name                = var.service_name
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "wowza-public" {
  name = "${var.service_name}-public"

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  sku = "Standard"

  frontend_ip_configuration {
    name                 = "wowza"
    public_ip_address_id = azurerm_public_ip.wowza.id
  }
  tags = var.tags
}

resource "azurerm_lb_probe" "wowza_rtmps-public" {
  resource_group_name = azurerm_resource_group.wowza.name
  loadbalancer_id     = azurerm_lb.wowza-public.id
  name                = "rtmps-running-probe"
  port                = 443
}

resource "azurerm_lb_probe" "wowza_rest-public" {
  resource_group_name = azurerm_resource_group.wowza.name
  loadbalancer_id     = azurerm_lb.wowza-public.id
  name                = "rest-running-probe"
  port                = 8087
}

resource "azurerm_lb_rule" "wowza-public" {
  resource_group_name            = azurerm_resource_group.wowza.name
  loadbalancer_id                = azurerm_lb.wowza-public.id
  name                           = "RTMPS-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "wowza"
  probe_id                       = azurerm_lb_probe.wowza_rtmps-public.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.wowza-public.id
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 30
}

resource "azurerm_lb_rule" "wowza_rest-public" {
  count = var.wowza_instance_count

  resource_group_name            = azurerm_resource_group.wowza.name
  loadbalancer_id                = azurerm_lb.wowza-public.id
  name                           = "REST-${count.index}"
  protocol                       = "Tcp"
  frontend_port                  = 8090 + count.index
  backend_port                   = 8087
  frontend_ip_configuration_name = "wowza"
  probe_id                       = azurerm_lb_probe.wowza_rest-public.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.wowza_vm-public[count.index].id
}

resource "azurerm_lb_backend_address_pool" "wowza-public" {
  resource_group_name = azurerm_resource_group.wowza.name
  loadbalancer_id     = azurerm_lb.wowza-public.id
  name                = "wowza"
}

resource "azurerm_lb_backend_address_pool" "wowza_vm-public" {
  count = var.wowza_instance_count

  resource_group_name = azurerm_resource_group.wowza.name
  loadbalancer_id     = azurerm_lb.wowza-public.id
  name                = "${var.service_name}-${count.index}"
}
