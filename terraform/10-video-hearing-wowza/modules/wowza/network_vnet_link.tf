locals {
  domain_env            = var.environment == "prod" ? "" : var.environment == "stg" ? "staging." : "${var.environment}."
  private_dns_zone      = "${local.domain_env}platform.hmcts.net"
  private_root_dns_zone = "platform.hmcts.net"
  private_dns_zone_rg   = "core-infra-intsvc-rg"
}

data "azurerm_private_dns_zone" "wowza" {
  provider = azurerm.private-endpoint-dns

  name                = local.private_dns_zone
  resource_group_name = local.private_dns_zone_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  provider = azurerm.private-endpoint-dns

  name                  = "${azurerm_virtual_network.wowza.name}-link"
  resource_group_name   = local.private_dns_zone_rg
  private_dns_zone_name = data.azurerm_private_dns_zone.wowza.name
  virtual_network_id    = azurerm_virtual_network.wowza.id
  registration_enabled  = false

  tags = var.tags
}

data "azurerm_private_dns_zone" "platform" {
  provider = azurerm.private-endpoint-dns

  name                = local.private_root_dns_zone
  resource_group_name = local.private_dns_zone_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "platform" {
  count    = var.environment == "prod" ? 0 : 1
  provider = azurerm.private-endpoint-dns

  name                  = "${azurerm_virtual_network.wowza.name}-link"
  resource_group_name   = local.private_dns_zone_rg
  private_dns_zone_name = data.azurerm_private_dns_zone.platform.name
  virtual_network_id    = azurerm_virtual_network.wowza.id
  registration_enabled  = false

  tags = var.tags
}