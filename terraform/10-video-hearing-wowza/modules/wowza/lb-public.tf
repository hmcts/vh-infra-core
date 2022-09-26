locals {
  frontend_ip_configuration_name = "wowza"
}
resource "azurerm_public_ip" "wowza" {
  name                = var.service_name
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
  domain_name_label   = var.service_name
}

resource "azurerm_lb" "wowza-public" {
  name = "${var.service_name}-public"

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  sku = "Standard"

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.wowza.id
  }
  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "wowza-public" {
  loadbalancer_id = azurerm_lb.wowza-public.id
  name            = "Wowza-Virtual-Machines"
}


resource "azurerm_lb_probe" "wowza_rtmps-public" {
  loadbalancer_id = azurerm_lb.wowza-public.id
  name            = "RTMPS-Probe"
  port            = 443
}

resource "azurerm_lb_probe" "wowza_ssh-public" {
  loadbalancer_id = azurerm_lb.wowza-public.id
  name            = "SSH-Probe"
  port            = 22
}

resource "azurerm_lb_rule" "wowza-public" {
  loadbalancer_id                = azurerm_lb.wowza-public.id
  name                           = "RTMPS-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = local.frontend_ip_configuration_name
  probe_id                       = azurerm_lb_probe.wowza_rtmps-public.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.wowza-public.id]
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 30
}

resource "azurerm_lb_rule" "ssh" {
  loadbalancer_id                = azurerm_lb.wowza-public.id
  name                           = "SSH-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = local.frontend_ip_configuration_name
  probe_id                       = azurerm_lb_probe.wowza_ssh-public.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.wowza-public.id]
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 30
}